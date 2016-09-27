${header()}
use std::mem;
use libc::*;


mod glue {
	use libc::*;

	extern {
		pub fn ${cklass}_c_1() -> *mut c_void;
% for mbr in fns.mbrs():
		pub fn ${cklass}_m_${mbr.cname}(${mbr.pp("cr", "this: *mut c_void")}) -> ${mbr.type.cr};
% endfor
		<%block name="glue" />
	}
}

/// ${brief}
pub struct ${klass}(pub *mut c_void);

impl ${klass}
{
	pub fn new() -> ${klass} {
		${klass}(unsafe { glue::${cklass}_c_1() })
	}

% for mbr in fns.mbrs():
	#[allow(non_snake_case)]
	pub fn ${mbr.rsname}(${mbr.pp("rs", "&self")}) -> ${mbr.type.rs} {
		<%block filter="mbr.ret('c2rs')">
			unsafe { glue::${cklass}_m_${mbr.cname}(${mbr.pp("rs2c", "self.0")}) }
		</%block>
	}

% endfor

% for mbr in fns.unsup():
	/// **Unimplemented**
	#[allow(non_snake_case)]
	pub fn ${mbr.cname}(&self) -> ! {
		unimplemented!();
	}

% endfor
}

// TODO: Drop

${next.body()}
