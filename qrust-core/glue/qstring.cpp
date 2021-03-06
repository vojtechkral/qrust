// Do not edit this file, it is auto-generated!

// Generated by qrust-gen
// Generator: GQString
// Template:  qstring_cpp.mako
// Timestamp: 2016-08-07T09:35:27Z

#include <QtCore/QString>

#include "common.h"

// CTOR

extern "C" void* _qrust_qstring_c_1() {
	return qshared2voidptr(QString());
}

// MEMBER TRAMPOLINES

extern "C" void _qrust_qstring_m_reserve(void* self, int size)
{
	auto obj = voidptr2qshared<QString>(self);
	return obj.reserve(size);
}
extern "C" void _qrust_qstring_m_push_front1(void* self, void* other)
{
	auto obj = voidptr2qshared<QString>(self);
	return obj.push_front(voidptr2qshared<QString>(other));
}
extern "C" void* _qrust_qstring_m_trimmed(void* self)
{
	auto obj = voidptr2qshared<QString>(self);
	return qshared2voidptr(obj.trimmed());
}
extern "C" void* _qrust_qstring_m_toUpper(void* self)
{
	auto obj = voidptr2qshared<QString>(self);
	return qshared2voidptr(obj.toUpper());
}
extern "C" void _qrust_qstring_m_squeeze(void* self)
{
	auto obj = voidptr2qshared<QString>(self);
	return obj.squeeze();
}
extern "C" int _qrust_qstring_m_length(void* self)
{
	auto obj = voidptr2qshared<QString>(self);
	return obj.length();
}
extern "C" void* _qrust_qstring_m_right(void* self, int n)
{
	auto obj = voidptr2qshared<QString>(self);
	return qshared2voidptr(obj.right(n));
}
extern "C" void _qrust_qstring_m_clear(void* self)
{
	auto obj = voidptr2qshared<QString>(self);
	return obj.clear();
}
extern "C" void* _qrust_qstring_m_left(void* self, int n)
{
	auto obj = voidptr2qshared<QString>(self);
	return qshared2voidptr(obj.left(n));
}
extern "C" void* _qrust_qstring_m_simplified(void* self)
{
	auto obj = voidptr2qshared<QString>(self);
	return qshared2voidptr(obj.simplified());
}
extern "C" int _qrust_qstring_m_isRightToLeft(void* self)
{
	auto obj = voidptr2qshared<QString>(self);
	return obj.isRightToLeft();
}
extern "C" void* _qrust_qstring_m_mid(void* self, int position, int n)
{
	auto obj = voidptr2qshared<QString>(self);
	return qshared2voidptr(obj.mid(position, n));
}
extern "C" int _qrust_qstring_m_isNull(void* self)
{
	auto obj = voidptr2qshared<QString>(self);
	return obj.isNull();
}
extern "C" void _qrust_qstring_m_chop(void* self, int n)
{
	auto obj = voidptr2qshared<QString>(self);
	return obj.chop(n);
}
extern "C" void* _qrust_qstring_m_toHtmlEscaped(void* self)
{
	auto obj = voidptr2qshared<QString>(self);
	return qshared2voidptr(obj.toHtmlEscaped());
}
extern "C" int _qrust_qstring_m_size(void* self)
{
	auto obj = voidptr2qshared<QString>(self);
	return obj.size();
}
extern "C" int _qrust_qstring_m_capacity(void* self)
{
	auto obj = voidptr2qshared<QString>(self);
	return obj.capacity();
}
extern "C" void _qrust_qstring_m_truncate(void* self, int position)
{
	auto obj = voidptr2qshared<QString>(self);
	return obj.truncate(position);
}
extern "C" void* _qrust_qstring_m_repeated(void* self, int times)
{
	auto obj = voidptr2qshared<QString>(self);
	return qshared2voidptr(obj.repeated(times));
}
extern "C" int _qrust_qstring_m_isEmpty(void* self)
{
	auto obj = voidptr2qshared<QString>(self);
	return obj.isEmpty();
}
extern "C" void* _qrust_qstring_m_toLower(void* self)
{
	auto obj = voidptr2qshared<QString>(self);
	return qshared2voidptr(obj.toLower());
}
extern "C" void _qrust_qstring_m_resize0(void* self, int size)
{
	auto obj = voidptr2qshared<QString>(self);
	return obj.resize(size);
}
extern "C" void* _qrust_qstring_m_toCaseFolded(void* self)
{
	auto obj = voidptr2qshared<QString>(self);
	return qshared2voidptr(obj.toCaseFolded());
}
extern "C" void _qrust_qstring_m_push_back1(void* self, void* other)
{
	auto obj = voidptr2qshared<QString>(self);
	return obj.push_back(voidptr2qshared<QString>(other));
}
extern "C" int _qrust_qstring_m_count0(void* self)
{
	auto obj = voidptr2qshared<QString>(self);
	return obj.count();
}
extern "C" int _qrust_qstring_m_localeAwareCompare0(void* self, void* other)
{
	auto obj = voidptr2qshared<QString>(self);
	return obj.localeAwareCompare(voidptr2qshared<QString>(other));
}



#include <iostream>

extern "C" void* _qrust_qstring_s_fromUtf8(const char *str, int size) {
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

