fn main() {
	println!("cargo:rustc-link-lib=stdc++");
	println!("cargo:rustc-link-lib=Qt5Core");
	println!("cargo:rustc-link-lib=Qt5Gui");
	println!("cargo:rustc-link-lib=Qt5Widgets");
	println!("cargo:rustc-link-search=native=glue");
	println!("cargo:rustc-link-lib=static=qr-glue");
}
