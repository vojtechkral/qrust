// Do not edit this file, it is auto-generated!

// Generated by qrust-gen
// Generator: GQObjectVtable
// Template:  qobject_vtable_h.mako
// Timestamp: 2016-08-07T09:35:27Z

#ifndef _QRUST_WIDGETS_QWIDGET_H
#define _QRUST_WIDGETS_QWIDGET_H

#include <QtWidgets/QWidget>

#include "common.h"

#include <iostream>
using std::cout;
using std::endl;


class VWidget: public QWidget
{
	Q_OBJECT
private:
	static const void *vtable_default[];
	void *vself;
	void **vtable;
public:
	VWidget(void* vself, void** vtable)
		:QWidget(),
		vself(vself ? vself : this),
		vtable(vtable ? vtable : const_cast<void**>(vtable_default))
	{}

	// virtuals:
	virtual int heightForWidth(int w) const;
	virtual void setVisible(bool visible);
	virtual bool hasHeightForWidth() const;
};

#endif // _QRUST_WIDGETS_QWIDGET_H
