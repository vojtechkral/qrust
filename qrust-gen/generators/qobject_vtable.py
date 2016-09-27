from . import generator
from . import qobject
from utils.types import *


class GQObjectVtable(qobject.GQObject):
	def __init__(self, qtmod, klass):
		super().__init__(qtmod, klass)
		self.setTargets([
			("qobject_vtable_h", "glue/{}.h".format(self.lklass)),
			("qobject_vtable_cpp", "glue/{}.cpp".format(self.lklass)),
			("qobject_vtable_rs", "src/{}.rs".format(self.lklass)),
		])

	def setData(self):
		# super().setData()
		self.data["cklass"] = "{}_{}".format(generator.QR_PREFIX, self.lklass)
		self.data["trait"] = "V" + self.klass.name[1:]
		self.data["ctrait"] = "{}_v{}".format(generator.QR_PREFIX, self.lklass[1:])
		self.data["fns"] = self.klass.fns(True)

		# self.data["vtable"] = True
		# self.data["mbrs"] = self.klass.getFns(virtual=False, kinds=["plain", "slot"], support=Function.S_SUPPORTED)
		# self.data["virts"] = self.klass.getFns(virtual=True, kinds=["plain", "slot"], support=Function.S_SUPPORTED)


def get():
	return GQObjectVtable
