from . import generator
from utils.types import *


class GQApp(generator.Generator):
	def __init__(self, qtmod, klass):
		super().__init__(qtmod, klass)
		self.setTargets([
			("qshareddata_cpp", "glue/{}.cpp".format(self.lklass)),
			("qshareddata_rs", "src/{}.rs".format(self.lklass)),
		])

	def generate(self, qtmod):
		# header = generator.template.get("qobject_vtable_h")
		# cpp = generator.template.get("qobject_vtable_cpp")
		# rs = generator.template.get("qobject_vtable_rs")
		# lklass = self.klass.lower()
		# data = {
		# 	"QR": generator.QR_PREFIX,
		# 	"qtmod": qtmod.name,
		# 	"klass": self.klass,
		# 	"rklass": "R" + self.klass[1:],
		# 	"cklass": "{}_{}".format(generator.QR_PREFIX, lklass),
		# 	"trait": "V" + self.klass[1:],
		# 	"ctrait": "{}_v{}".format(generator.QR_PREFIX, lklass[1:]),
		# }
		# header = header.render(**data)
		# cpp = cpp.render(**data)
		# rs = rs.render(**data)
		# with open("{}/glue/{}.h".format(qtmod.dir, lklass), "w") as f:
		# 	f.write(header)
		# with open("{}/glue/{}.cpp".format(qtmod.dir, lklass), "w") as f:
		# 	f.write(cpp)
		# with open("{}/src/{}.rs".format(qtmod.dir, lklass), "w") as f:
		# 	f.write(rs)

def get():
	return GQApp
