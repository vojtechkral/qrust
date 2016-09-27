from . import generator


class GModule(generator.Generator):
	def __init__(self, qtmod):
		super().__init__(qtmod)
		self.setTargets([
			("cmakelists_txt", "glue/CMakeLists.txt"),
			("common_h", "glue/common.h"),
			("lib_rs", "src/lib.rs"),
		])

	def addModFiles(self):
		pass

	def setData(self):
		self.data["lib"] = "qrust-{}-glue".format(self.qtmod.name)
		self.data["pkgname"] = self.qtmod.pkgname
		self.data["deps"] = self.qtmod.deps
		self.data["cppfiles"] = self.qtmod.cppfiles
		self.data["rsmods"] = self.qtmod.rsmods

def get():
	return GModule
