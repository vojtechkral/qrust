extern crate cmake;


fn main() {
	let dst = cmake::build("glue");

	// TODO: needed?
	println!("cargo:rustc-link-lib=stdc++");
	println!("cargo:rustc-link-lib=Qt5Gui");
	println!("cargo:rustc-link-lib=Qt5Widgets");

	println!("cargo:rustc-link-search=native={}", dst.display());
	println!("cargo:rustc-link-lib=static=qrust-widgets-glue");
}
