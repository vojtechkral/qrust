${header()}
#ifndef ${QR.upper()}_${qtmod.upper()}_COMMON_H
#define ${QR.upper()}_${qtmod.upper()}_COMMON_H

#include <memory>

#include <QtCore/QObject>
#include <QtCore/QMetaObject>


struct TraitObject
{
	void *data;
	void *vtable;
};

struct FatPtr
{
	void *p1;
	void *p2;
};

template<typename T> struct Rptr
{
public:
	Rptr(T* self, const TraitObject& rptr)
	{
		self->rptr = rptr;
	}
};

template<class T> void* qshared2voidptr(const T& qshared) {
	static_assert(sizeof(T) == sizeof(void*) && alignof(T) == alignof(void*), "Size/align mismatch!");
	// We need to prevent T's destructor from running and decreasing the refcount.
	// The following ugly hack sould do the trick:
	void *voidptr;
	new (&voidptr) T(qshared);
	return voidptr;
}

template<class T> T voidptr2qshared(void *self) {
	static_assert(sizeof(T) == sizeof(void*) && alignof(T) == alignof(void*), "Size/align mismatch!");
	T *obj = reinterpret_cast<T*>(&self);
	return *obj;
}

class Signal: public QObject
{
	Q_OBJECT
protected:
	TraitObject callback;
public:
	Signal(TraitObject callback) :callback(callback) {}
	virtual ~Signal()
	{
		// Descendants actually implement destroying the closure
	}
};

class Connection {
private:
	std::unique_ptr<Signal> signal;
	QMetaObject::Connection con;
public:
	Connection(QMetaObject::Connection con) :con(con) {}
	Connection(std::unique_ptr<Signal> signal, QMetaObject::Connection con)
		:signal(std::move(signal)), con(con) {}

	template<class SRC, class SG, class SGMBR>
	static Connection* connect(void* obj, TraitObject data, bool closure,
		SGMBR sgmbr, const char* sgstr)
	{
		auto src = static_cast<SRC*>(obj);
		if (closure)
		{
			auto sg = new SG(data);
			auto con = QObject::connect(src, sgmbr, sg, &SG::trampoline);
			return new Connection(std::unique_ptr<Signal>(sg), con);
		} else
		{
			auto receiver = static_cast<QObject*>(data.data);
			auto slot = static_cast<const char*>(data.vtable);
			return new Connection(receiver->connect(src, sgstr, slot));
		}
	}

	bool disconnect()
	{
		return QObject::disconnect(con);
	}
};

#endif  // ${QR.upper()}_${qtmod.upper()}_COMMON_H
