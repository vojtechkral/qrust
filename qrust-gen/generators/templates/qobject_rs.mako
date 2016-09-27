${header()}
use std::mem;
use std::ptr::null_mut;
use libc::*;

use ${qr_core}::{TraitObject, FatPtr, QPtr, AsQPtr, Connection, Slot, IntoSlot};


// GLUE DECLS

mod glue {
	use libc::*;
	use ${qr_core}::TraitObject;

	extern {
<%block name="ctor">
		pub fn ${cklass}_c_1() -> *mut c_void;
</%block>
% for mbr in fns.mbrs():
		pub fn ${cklass}_m_${mbr.cname}(${mbr.pp("cr", "this: *mut c_void")}) -> ${mbr.type.cr};
% endfor
% for sg in fns.signals():
		pub fn ${cklass}_C_${sg.name}(obj: *mut c_void, callback: TraitObject, closure: c_int) -> *mut c_void;
% endfor
		<%block name="glue" />
	}
}

// NATIVE SLOTS
// TODO

pub mod slot
{
	#[allow(non_snake_case)]
	pub mod ${klass}
	{
		use ${qr_core}::{AsQPtr, TraitObject, Slot};

		mod glue {
			use libc::*;

			extern {
				pub static mut ${cklass}_S_close: *mut c_void;
			}
		}

		pub fn close(qobj: &::${klass}) -> Slot
		{
			Slot::Native(TraitObject
			{
				data: qobj.qptr(),
				vtable: unsafe { glue::${cklass}_S_close },
			})
		}
	}
}


// CLASS

/// ${brief}
pub struct ${klass}(QPtr);

impl ${klass}
{
<%block name="klass_impl">
  pub fn new() -> ${klass} {
		${klass}(unsafe { glue::${cklass}_c_1() })
	}
</%block>

	// MEMBERS

% for mbr in fns.mbrs():
	#[allow(non_snake_case)]
	pub fn ${mbr.cname}(${mbr.pp("rs", "&self")}) -> ${mbr.type.rs} {
		<%block filter="mbr.ret('c2rs')">
			unsafe { glue::${cklass}_m_${mbr.cname}(${mbr.pp("rs2c", "self.0")}) }
		</%block>
	}

% endfor

	// UNSUPPORTEDS

% for mbr in fns.unsup():
	/// **Unimplemented:** `${klass}::${mbr.name}(${mbr.pp()})`
	#[allow(non_snake_case)]
	pub fn ${mbr.cname}(&self) -> ! {
		unimplemented!();
	}

% endfor

	// SIGNALS

% for sg in fns.signals():
	#[allow(non_snake_case)]
	pub fn ${sg.name}<T>(&self, slot: T) -> Connection
		where T: IntoSlot<(${sg.pp("rst")})>
	{
		let slot = slot.into_slot();
		slot.connect(|to, closure| -> *mut c_void
		{
			unsafe { glue::${cklass}_C_${sg.name}(self.0, to, closure as c_int) }
		})
	}

% endfor
}

impl AsQPtr for ${klass} {
	fn qptr(&self) -> QPtr { self.0 }
	fn set_qptr(&mut self, qptr: QPtr) { self.0 = qptr; }
}


// SIGNAL CLOSURE TRAMPOLINES

% for sg in fns.signals():
#[no_mangle]
#[doc(hidden)]
#[allow(non_snake_case)]
pub extern fn ${cklass}_T_${sg.name}(${sg.pp("cr", "callback: TraitObject")}) {
	let cb: Box<Fn(${sg.pp("rst")}) + 'static> = unsafe { Box::from_raw(mem::transmute(callback)) };
	cb(${sg.pp("c2rs")});
	mem::forget(cb);
}

% endfor


// SIGNAL CLOSURE DROPS

% for sg in fns.signals():
#[no_mangle]
#[doc(hidden)]
#[allow(non_snake_case)]
pub extern fn ${cklass}_D_${sg.name}(callback: TraitObject) {
	let _cb: Box<Fn(${sg.pp("rst")}) + 'static> = unsafe { Box::from_raw(mem::transmute(callback)) };
}

% endfor


${next.body()}
