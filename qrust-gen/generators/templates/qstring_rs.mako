<%inherit file="qshareddata_rs.mako"/>

<%block name="glue">
	pub fn ${cklass}_s_fromUtf8(str: *const c_char, size: c_int) -> *mut c_void;
	pub fn ${cklass}_x_utf16_tmp(this: *mut c_void) -> *const c_ushort;
</%block>

use std::convert::{From, Into};
use std::slice;

## TODO: impl these for &str too...

impl From<String> for QString {
	fn from(s: String) -> QString {
		QString(unsafe { glue::${cklass}_s_fromUtf8(s.as_ptr() as *const c_char,
			s.len() as c_int) })
	}
}

impl Into<String> for QString {
	fn into(self) -> String {
		// FIXME: tmp
		let len = self.length();
		let utf16 = unsafe { glue::${cklass}_x_utf16_tmp(self.0) };
		String::from_utf16(unsafe { slice::from_raw_parts(utf16, len as usize) }).unwrap()
	}
}
