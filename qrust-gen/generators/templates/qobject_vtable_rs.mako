<%inherit file="qobject_rs.mako"/>\

<%block name="ctor">
  pub fn ${cklass}_c_1(vself: *mut c_void, vtable: *const c_void) -> *mut c_void;
</%block>

<%block name="glue">
% for v in fns.virts():
	pub fn ${cklass}_m_${v.name}(${v.pp("cr", "this: *mut c_void")}) -> ${v.type.cr};
	pub fn ${cklass}_v_${v.name}(${v.pp("cr", "this: *mut c_void")}) -> ${v.type.cr};
% endfor
</%block>


pub trait RepaintArgs {
	fn call(&self, QPtr);
}

impl RepaintArgs for () {
	fn call(&self, qptr: QPtr) {
		return unsafe { glue::_qrust_qwidget_m_repaint0(qptr) };
	}
}

impl RepaintArgs for (i32, i32, i32, i32) {
	fn call(&self, qptr: QPtr) {
		return unsafe { glue::_qrust_qwidget_m_repaint3(
			qptr, self.0 as c_int, self.1 as c_int, self.2 as c_int, self.3 as c_int) };
	}
}

<%block name="klass_impl">
	pub fn new() -> ${klass} {
		${klass}(unsafe { glue::${cklass}_c_1(null_mut(), null_mut()) })
	}

	pub fn new_null() -> ${klass} {
		${klass}(null_mut())
	}

	pub fn with_vtable<T: ${trait}>(obj: T) -> Box<T> {
		let mut ret = Box::new(obj);
		let vself: *mut c_void = unsafe { mem::transmute(&*ret) };
		let vtable = unsafe { T::${QR}_vtable() };
		ret.set_qptr(unsafe { glue::${cklass}_c_1(vself, vtable) });
		ret
	}

	pub fn repaint<T: RepaintArgs>(&self, args: T) -> () {
		args.call(self.0)
	}
</%block>

use std::ops::Deref;
use std::sync::atomic::{AtomicPtr, Ordering};

use ${qr_core}::{QDefault, QString};


// TRAIT

<% VTABLE = "{}_{}_VTABLE".format(QR, trait.upper()) %>
#[allow(non_upper_case_globals)]
static ${VTABLE}: AtomicPtr<()> = AtomicPtr::new(null_mut());

/// Virtual table for ${klass}
pub trait ${trait}: AsQPtr {

	#[doc(hidden)]
	unsafe fn ${QR}_vtable() -> *const c_void {
		let vtable = ${VTABLE}.load(Ordering::SeqCst);
		if !vtable.is_null() {
			return vtable as *const c_void;
		}

		let vtable = calloc(${len(list(fns.virts()))}, mem::size_of::<usize>());
		let vtable_array: *mut *mut c_void = mem::transmute(vtable);
% for v in fns.virts():
		*vtable_array.offset(${loop.index}) = mem::transmute(Self::${v.name} as usize);
% endfor

		let prev = ${VTABLE}.compare_and_swap(null_mut(), vtable as *mut (), Ordering::SeqCst);
		if prev.is_null() {
			vtable
		} else {
			// Someone created the vtable in the meantime
			free(vtable);
			prev as *const c_void
		}
	}

// VIRTUALS

% for v in fns.virts():
	#[allow(non_snake_case)]
	fn ${v.name}(${v.pp("rs", "&self")}) -> ${v.type.rs} {
		<%block filter="v.ret('c2rs')">
			unsafe { glue::${cklass}_v_${v.name}(${v.pp("rs2c", "self.qptr()")}) }
		</%block>
	}

% endfor
}


// VIRTUAL TRAMPOLINES

% for v in fns.virts():
#[no_mangle]
#[doc(hidden)]
#[allow(non_snake_case)]
pub extern fn ${ctrait}_${v.name}(${v.pp("cr", "ptr: FatPtr")}) -> ${v.type.cr} {
	let f: fn(${v.pp("rst", "*mut c_void")}) -> ${v.type.rs} = unsafe { mem::transmute(ptr.p2) };
	<%block filter="v.ret('rs2c')">
		f(${v.pp("c2rs", "ptr.p1")})
	</%block>
}

% endfor


// TRAIT IMPL

impl ${trait} for ${klass} {
% for v in fns.virts():
	fn ${v.name}(${v.pp("rs", "&self")}) -> ${v.type.rs} {
		<%block filter="v.ret('c2rs')">
			unsafe { glue::${cklass}_m_${v.name}(${v.pp("rs2c", "self.0")}) }
		</%block>
	}

% endfor
}

impl<'a, T: ${trait}> ${trait} for QDefault<${}&'a T> {}
