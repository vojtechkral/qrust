from . import qshareddata

class GQString(qshareddata.GQSharedData):
	def __init__(self, qtmod, klass):
		super().__init__(qtmod, klass)
		self.setTargets([
			("qstring_cpp", "glue/{}.cpp".format(self.lklass)),
			("qstring_rs", "src/{}.rs".format(self.lklass)),
		])


def get():
	return GQString
