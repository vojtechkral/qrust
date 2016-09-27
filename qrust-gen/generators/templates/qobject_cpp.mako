<%namespace file="defs.mako" import="*"/>\
${header()}
#include <iostream>
#include <Qt${qtmod.capitalize()}/${klass}>
#include "common.h"

// FIXME: TMP
using std::cout;
using std::endl;


// MEMBER TRAMPOLINES

<%block name="ctor">
extern "C" void* ${cklass}_c_1() {
	return new ${klass}();
}
</%block>

% for mbr in fns.mbrs():
extern "C" ${mbr.type.c} ${cklass}_m_${mbr.cname}(${mbr.pp("c", "void* self")}) {
	<%block filter="mbr.ret('cpp2c')">
		static_cast<${klass}*>(self)->${mbr.name}(${mbr.pp("c2cpp")})
	</%block>
}
% endfor


// SLOTS:

const char* ${cklass}_S_close = SLOT(close());


// SIGNALS:

% for sg in fns.signals():
extern "C" void ${cklass}_T_${sg.name}(${sg.pp("ct", "TraitObject")});
extern "C" void ${cklass}_D_${sg.name}(TraitObject);

class ${klass}_${sg.name}: public Signal
{
public:
	${klass}_${sg.name}(TraitObject callback) :Signal(callback) {}
	virtual ~${klass}_${sg.name}() { ${cklass}_D_${sg.name}(callback); }
public slots:
	void trampoline(${sg.pp("cpp")})
	{
		cout << "${klass}_${sg.name}::trampoline" << endl;
		${cklass}_T_${sg.name}(${sg.pp("cpp2c", "callback")});
	}
};

extern "C" void* ${cklass}_C_${sg.name}(void* obj, TraitObject data, int closure)
{
	return Connection::connect<${klass}, ${klass}_${sg.name}>(
		obj, data, closure,
		&${klass}::${sg.name}, SIGNAL(${sg.name}(${sg.pp("cppt")})));
}
% endfor


${next.body()}
