<%inherit file="qshareddata_cpp.mako"/>

#include <iostream>

extern "C" void* ${cklass}_s_fromUtf8(const char *str, int size) {
	QString qstr = QString::fromUtf8(str, size);
	std::cout << "QString::fromUtf8: " << qstr.toUtf8().data() << std::endl;
	std::cout << "alignof(QString): " << alignof(QString) << std::endl;
	return qshared2voidptr(qstr);
}

extern "C" const ushort* _qrust_qstring_x_utf16_tmp(void* self)
{
	auto qstr = voidptr2qshared<QString>(self);
	return qstr.utf16();
}
