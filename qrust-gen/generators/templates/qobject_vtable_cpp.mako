<%inherit file="qobject_cpp.mako"/>\

#include "${klass.lower()}.h"

// CONSTRUCTORS

## FIXME: HACK
<%block name="ctor">
</%block>
extern "C" void* ${cklass}_c_1(void* vself, void* vtable) {
	return new ${trait}(vself, static_cast<void**>(vtable));
}


// VIRTUAL MEMBER TRAMPOLINES

% for v in fns.virts():
extern "C" ${v.type.c} ${cklass}_m_${v.name}(${v.pp("c", "void* self")}) {
	<%block filter="v.ret('cpp2c')">
		static_cast<${trait}*>(self)->${v.name}(${v.pp("c2cpp")})
	</%block>
}

% endfor


// TRAIT TRAMPOLINES

% for v in fns.virts():
extern "C" ${v.type.c} ${ctrait}_${v.name}(${v.pp("ct", "FatPtr")});
% endfor


// CLASS VIRTUALS

% for v in fns.virts():
${v.type.cpp} ${trait}::${v.name}(${v.pp("cpp")})${v.const} {
	FatPtr ptr = { vself, vtable[${loop.index}] };
	<%block filter="v.ret('c2cpp')">
		${ctrait}_${v.name}(${v.pp("cpp2c", "ptr")})
	</%block>
}

% endfor


// VIRTUAL DEFAULT TRAMPOLINES

% for v in fns.virts():
extern "C" ${v.type.c} ${cklass}_v_${v.name}(${v.pp("c", "void* self")}) {
	<%block filter="v.ret('cpp2c')">
		static_cast<${trait}*>(self)->${klass}::${v.name}(${v.pp("c2cpp")})
	</%block>
}

% endfor

// DEFAULT VTABLE

const void *${trait}::vtable_default[] = {
% for v in fns.virts():
	reinterpret_cast<void*>(&${cklass}_v_${v.name}),
% endfor
};
