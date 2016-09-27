import re

class Type(object):
	def __init__(self, cpp, c, cr, rs,
		cpp2c=None, c2cpp=None, rs2c=None, c2rs=None):
		self.cpp = cpp
		self.c = c
		self.cr = cr
		self.rs = rs
		self.fmts = {
			"cpp": "{} {{}}".format(cpp),      # C++ def,      ie. "bool foobar"
			"cppt": cpp,                       # C++ decl,     ie. "bool"
			"c": "{} {{}}".format(c),          # C def,        ie. "int foobar"
			"ct": "{}".format(c),              # C decl,       ie. "int"
			"cr": "{{}}: {}".format(cr),       # Rust FFI def, ie. "foobar: c_int"
			"rs": "{{}}: {}".format(rs),       # Rust def,     ie. "foobar: bool"
			"rst": rs,                         # Rust decl,    ie. "bool"
			"cpp2c": cpp2c if cpp2c is not None else "{}",
			"c2cpp": c2cpp if c2cpp is not None else "{}",
			"rs2c": rs2c if rs2c is not None else "{{}} as {}".format(cr),
			"c2rs": c2rs if c2rs is not None else "{{}} as {}".format(rs),
		}

	def fmt(self, kind, what):
		return self.fmts[kind].format(what)

class TypeMap(object):
	def __init__(self):
		self.types = {}
		self.add(Type(cpp="void", c="void", cr="()", rs="()", rs2c="{}", c2rs="{}"))
		self.add(Type(cpp="bool", c="int", cr="c_int", rs="bool",
			c2rs="{} != 0"))
		self.add(Type(cpp="int", c="int", cr="c_int", rs="i32"))

	def add(self, type):
		self.types[type.cpp] = type

	def get(self, cppname):
		return self.types[cppname] if cppname in self.types else None

typemap = TypeMap()


rust_keywords = [
	"abstract", "alignof", "as", "become", "box",
	"break", "const", "continue", "crate", "do",
	"else", "enum", "extern", "false", "final",
	"fn", "for", "if", "impl", "in",
	"let", "loop", "macro", "match", "mod",
	"move", "mut", "offsetof", "override", "priv",
	"proc", "pub", "pure", "ref", "return",
	"Self", "self", "sizeof", "static", "struct",
	"super", "trait", "true", "type", "typeof",
	"unsafe", "unsized", "use", "virtual", "where",
	"while", "yield"
]

def keyword_rename(name):
	return name+"_" if name in rust_keywords else name

_re_kind_op = re.compile("^operator[^a-zA-Z0-9_]+$")
def kind_extended(name, kind):
	if kind == "plain":
		if _re_kind_op.match(name):
			return "operator"
	return kind

class Param(object):
	def __init__(self, meta, num):
		self.name = meta["name"] if meta["name"] else "arg{}".format(num)
		self.name = keyword_rename(self.name)
		self.type = typemap.get(meta["left"])

	def supported(self):
		return self.type is not None

	def fmt(self, kind):
		return self.name if kind is None \
		else self.type.fmt(kind, self.name)

class Function(object):
	SUPPORTED_KINDS = ["plain", "slot", "signal"]
	S_HIDE = -1
	S_UNSUPPORTED = 0
	S_SUPPORTED = 1

	def __init__(self, meta, excl):
		self.name = meta["name"]
		self.kind = kind_extended(self.name, meta["meta"])
		self.excl = self.name in excl
		self.rsname = self.cname = keyword_rename(self.name)
		self.overloaded = False
		self.const = " const" if meta["const"] == "true" else ""
		self.type = typemap.get(meta["type"])
		self.virtual = meta["virtual"] == "virtual"
		self.params = [
			Param(p, i) for i, p in enumerate(meta.find_all("parameter", recursive=False))
		]
		self.support = self.supported()

	def supported(self):
		if self.excl:
			return Function.S_HIDE
		if self.kind not in Function.SUPPORTED_KINDS:
			return Function.S_HIDE
		if self.type is None:
			return Function.S_UNSUPPORTED
		for p in self.params:
			if not p.supported():
				return Function.S_UNSUPPORTED
		return Function.S_SUPPORTED

	def pp(self, type=None, first=None):
		"""Print parameters (for template use)"""
		ret = ""
		if first is not None:
			ret += first
		for i, p in enumerate(self.params):
			if i > 0 or first is not None:
				ret += ", "
			ret += p.fmt(type)
		return ret

	def ret(self, kind):
		def filter(invocation):
			return "return {};".format(self.type.fmt(kind, invocation.strip()))
		return filter

	def match(self, vtable, virtual, support, kinds):
		return \
			(not vtable or virtual is None or self.virtual == virtual) and \
			(support is None or self.support == support) and \
			(kinds is None or self.kind in kinds)


class Functions(object):
	"""Reads functions, renames overloads"""
	def __init__(self, klassmeta, excl, vtable):
		fns = {}
		for fmeta in klassmeta.find_all("function", {
				"access": "public",   # TODO: protected?
				"static": "false",
				"delete": "false",
			}):
			f = Function(fmeta, excl)
			if not f.name in fns:
				fns[f.name] = [f]
			else:
				fns[f.name].append(f)
		# res = []
		for fname in fns:
			# if len(fns[fname]) == 1:
			# 	res.append(fns[fname][0])
			# else:
			if len(fns[fname]) > 1:
				# TODO: overloading support
				for i, f in enumerate(fns[fname]):
					if f.support != Function.S_HIDE:   # Ignore those
						f.overloaded = True
						f.cname = "{}{}".format(f.name, i)
					# res.append(f)
			if fname == "data":
				print("{}".format([f.cname for f in fns[fname]]))
		# self.fns = res
		self.fns = fns
		self.vtable = vtable

	def get(self, virtual=None, support=None, kinds=None, overload=False):
		for fname in self.fns:
			if overload:
				# FIXME
				# f = self.fns[fname][0]
				# if f.match(self.vtable, virtual, support, kinds):
				# 	yield f
			else:
				for f in self.fns[fname]:
					if f.match(self.vtable, virtual, support, kinds):
						yield f

	def mbrs(self, overload=False):
		return self.get(virtual=False, kinds=["plain", "slot"], support=Function.S_SUPPORTED, overload=overload)

	def signals(self):
		return self.get(kinds=["signal"], support=Function.S_SUPPORTED)

	def unsup(self, overload=False):
		return self.get(support=Function.S_UNSUPPORTED, overload=overload)

	def virts(self, overload=False):
		return self.get(virtual=True, kinds=["plain", "slot"], support=Function.S_SUPPORTED, overload=overload)


class Klass(object):
	def __init__(self, meta, conf):
		self.meta = meta
		self.name = meta["name"]
		self.brief = meta["brief"]
		self.conf = conf
		self.excl = [ e.get_text() for e in conf.find_all("exclude", recursive=False) ]

	# def loadFns(self):

	# def getFns(self, virtual=None, support=None, kinds=None):
	# 	def predicate(f):
	# 		return \
	# 			(virtual is None or f.virtual == virtual) and \
	# 			(support is None or f.support == support) and \
	# 			(kinds is None or f.kind in kinds)
	# 	return [ f for f in self.fns if predicate(f) ]

	# def fns(self, virtual=None, support=None, kinds=None, overload=False):
	# 	for fname in self.fns:
	# 		if overload:
	# 			yield self.fns[fname][0]
	# 		else
	# 			for f in self.fns[fname]:
	# 				if \
	# 					(virtual is None or f.virtual == virtual) and \
	# 					(support is None or f.support == support) and \
	# 					(kinds is None or f.kind in kinds):
	# 					yield f

	def fns(self, vtable):
		return Functions(self.meta, self.excl, vtable)

