from . import generator
from utils.types import *


class GQSharedData(generator.Generator):
	def __init__(self, qtmod, klass):
		super().__init__(qtmod, klass)
		self.setTargets([
			("qshareddata_cpp", "glue/{}.cpp".format(self.lklass)),
			("qshareddata_rs", "src/{}.rs".format(self.lklass)),
		])

	def addModFiles(self):
		self.qtmod.addCpp("{}.cpp".format(self.lklass))
		self.qtmod.addRs(self.lklass)

	def addTypes(self, typemap):
		typemap.add(Type(
			cpp=self.klass.name,
			c="void*",
			cr="*mut c_void",
			rs=self.klass.name,
			cpp2c="qshared2voidptr({})",
			c2cpp="voidptr2qshared<{}>({{}})".format(self.klass.name),
			rs2c="{}.0",
			c2rs="{}({{}})".format(self.klass.name)
		))
		typemap.add(Type(
			cpp="const {} &".format(self.klass.name),
			c="void*",
			cr="*mut c_void",
			rs="{}".format(self.klass.name),
			cpp2c="qshared2voidptr({})",
			c2cpp="voidptr2qshared<{}>({{}})".format(self.klass.name),
			rs2c="{}.0",
			c2rs="{}({{}})".format(self.klass.name)
		))

	def setData(self):
		self.data["cklass"] = "{}_{}".format(generator.QR_PREFIX, self.lklass)
		self.data["fns"] = self.klass.fns(False)
		# self.data["mbrs"] = self.klass.getFns(False, Function.S_SUPPORTED)
		# self.data["unsup"] = self.klass.getFns(False, Function.S_UNSUPPORTED)

def get():
	return GQSharedData
