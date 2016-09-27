${header()}
#include <Qt${qtmod.capitalize()}/${klass}>

#include "common.h"

// CTOR

extern "C" void* ${cklass}_c_1() {
	return qshared2voidptr(${klass}());
}

// MEMBER TRAMPOLINES

% for mbr in fns.mbrs():
extern "C" ${mbr.type.c} ${cklass}_m_${mbr.cname}(${mbr.pp("c", "void* self")})
{
	auto obj = voidptr2qshared<${klass}>(self);
	<%block filter="mbr.ret('cpp2c')">
		obj.${mbr.name}(${mbr.pp("c2cpp")})
	</%block>
}
% endfor

${next.body()}
