${header()}
#ifndef ${QR.upper()}_${qtmod.upper()}_${klass.upper()}_H
#define ${QR.upper()}_${qtmod.upper()}_${klass.upper()}_H

#include <Qt${qtmod.capitalize()}/${klass}>

#include "common.h"

## FIXME: TMP
#include <iostream>
using std::cout;
using std::endl;


class ${trait}: public ${klass}
{
	Q_OBJECT
private:
	static const void *vtable_default[];
	void *vself;
	void **vtable;
public:
	${trait}(void* vself, void** vtable)
		:${klass}(),
		vself(vself ? vself : this),
		vtable(vtable ? vtable : const_cast<void**>(vtable_default))
	{}

	// virtuals:
% for v in fns.virts():
	virtual ${v.type.cpp} ${v.name}(${v.pp("cpp")})${v.const};
% endfor
};

#endif // ${QR.upper()}_${qtmod.upper()}_${klass.upper()}_H
