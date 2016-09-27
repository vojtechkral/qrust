from . import generator
from utils.types import *


class GQObject(generator.Generator):
	def __init__(self, qtmod, klass):
		super().__init__(qtmod, klass)
		self.setTargets([
			("qobject_cpp", "glue/{}.cpp".format(self.lklass)),
			("qobject_rs", "src/{}.rs".format(self.lklass)),
		])

	def addModFiles(self):
		self.qtmod.addCpp("{}.cpp".format(self.lklass))
		self.qtmod.addRs(self.lklass)

	def setData(self):
		self.data["cklass"] = "{}_{}".format(generator.QR_PREFIX, self.lklass)
		self.data["fns"] = self.klass.fns(False)
		# self.data["mbrs"] = self.klass.getFns(kinds=["plain", "slot"], support=Function.S_SUPPORTED)
		# self.data["signals"] = self.klass.getFns(kinds=["signal"], support=Function.S_SUPPORTED)
		# self.data["unsup"] = self.klass.getFns(support=Function.S_UNSUPPORTED)
		# self.data["vtable"] = False


def get():
	return GQObject
