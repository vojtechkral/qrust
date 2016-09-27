${header()}
#![feature(const_fn)]

extern crate libc;
% for d in deps:
extern crate qr_${d.name};
% endfor

% for m in rsmods:
mod ${m};
% endfor

% for m in rsmods:
pub use ${m}::*;
% endfor
