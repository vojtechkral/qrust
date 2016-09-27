use std::mem;
use std::ptr::null_mut;
use libc::*;

use ::qstring::QString;

mod glue {
	use libc::*;

	extern {
		pub fn connection_disconnect(obj: *mut c_void) -> c_int;
	}
}

#[repr(C)]
#[derive(Clone, Debug)]
pub struct TraitObject {
	// Compatible with std::raw::TraitObject
	pub data: *mut c_void,
	pub vtable: *mut c_void,
}

#[repr(C)]
#[derive(Clone, Debug)]
pub struct FatPtr {
	pub p1: *mut c_void,
	pub p2: *mut c_void,
}

impl Default for TraitObject {
	fn default() -> TraitObject {
		TraitObject{ data: null_mut(), vtable: null_mut() }
	}
}

pub type NativeSlot = *mut c_void;

pub type QPtr = *mut c_void;

pub trait AsQPtr {
	fn qptr(&self) -> QPtr;
	fn set_qptr(&mut self, qptr: QPtr);
}

pub struct QDefault<T>(pub T);

impl<'a, T: AsQPtr> AsQPtr for QDefault<&'a T> {
	fn qptr(&self) -> QPtr { self.0.qptr() }
	fn set_qptr(&mut self, qptr: QPtr) { /* no-op */ }
}

pub struct Connection(*mut c_void);

impl Connection
{
	pub fn from_native(con: *mut c_void) -> Connection { Connection(con) }

	pub fn disconnect(self) -> bool
	{
		unsafe { glue::connection_disconnect(self.0) != 0 }
	}
}

pub enum Slot
{
	Native(TraitObject),
	Closure(TraitObject),
}

impl Slot {
	pub fn connect<F>(self, via: F) -> Connection
		where F: Fn(TraitObject, bool) -> *mut c_void
	{
		let con = match self
		{
			Slot::Native(to) => { via(to, false) },
			Slot::Closure(to) => { via(to, true) },
		};
		Connection::from_native(con)
	}
}

pub trait IntoSlot<Args>
{
	fn into_slot(self) -> Slot;
}

impl<Args> IntoSlot<Args> for Slot
{
	fn into_slot(self) -> Slot { self }
}




// TODO: ? for all signals
//       - or for type-aliases ??? - conflicts ???
//       - move to crate root, if at all possible

impl<F> IntoSlot<()> for F where F: Fn() + 'static
{
	fn into_slot(self) -> Slot
	{
		let boxed: Box<Fn() + 'static> = Box::new(self);
		let to = unsafe { mem::transmute(Box::into_raw(boxed)) };
		Slot::Closure(to)
	}
}

impl<F> IntoSlot<QString> for F where F: Fn(QString) + 'static
{
	fn into_slot(self) -> Slot
	{
		let boxed: Box<Fn(QString) + 'static> = Box::new(self);
		let to = unsafe { mem::transmute(Box::into_raw(boxed)) };
		Slot::Closure(to)
	}
}
