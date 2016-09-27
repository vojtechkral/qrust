extern crate cmake;


fn main() {
	let dst = cmake::build("glue");

	println!("cargo:rustc-link-lib=stdc++");
	println!("cargo:rustc-link-lib=Qt5Core");
	println!("cargo:rustc-link-search=native={}", dst.display());
	println!("cargo:rustc-link-lib=static=qrust-core-glue");
}
