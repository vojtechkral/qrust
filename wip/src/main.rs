extern crate libc;
extern crate qr_core;
extern crate qr_widgets;

use std::ops::Deref;
// use std::mem;

use qr_core::{QPtr, AsQPtr, QDefault, QString, QTimer};
use qr_widgets::{QWidget, VWidget};
use qr_widgets::slot;

mod sys {
	use libc::*;

	extern {
		pub fn qapplication_create() -> *mut c_void;
		pub fn qapplication_exec(this: *mut c_void);
		pub fn qapplication_delete(this: *mut c_void);
	}
}

struct MyWidget {
	w: QWidget,
	mydata: u32,
}

impl MyWidget {
	pub fn new() -> Box<MyWidget> {
		let mywidget = MyWidget{
			w: QWidget::new_null(),
			mydata: 3,
		};
		QWidget::with_vtable(mywidget)
	}
}

impl AsQPtr for MyWidget {
	fn qptr(&self) -> QPtr { self.w.qptr() }
	fn set_qptr(&mut self, qptr: QPtr) { self.w.set_qptr(qptr); }
}

impl Deref for MyWidget {
	type Target = QWidget;

	fn deref(&self) -> &QWidget {
		&self.w
	}
}

impl VWidget for MyWidget {
	fn setVisible(&self, _visible: bool) -> () {
		println!("MyWidget::setVisible() ... overriding!");
		println!("\tmydata: {}", self.mydata);
		QDefault(self).setVisible(false);
	}
}

fn main() {
	let app = unsafe { sys::qapplication_create() };

	let widget = QWidget::new();
	widget.show();
	println!("hasHeightForWidth: {}", widget.hasHeightForWidth());
	let con = widget.windowTitleChanged(move |title: QString| {
		println!("Received signal from QWidget!");
		let title: String = title.into();
		println!("\tNew title: {}", title);
	});
	// println!("Disconnect: {}", con.disconnect());
	// let con_ntv = widget.windowTitleChanged(slot::QWidget::close(&widget));
	// println!("Disconnect: {}", con_ntv.disconnect());
	// widget.pk();
	let newtitle = QString::from(String::from("Hello, World!"));
	widget.setWindowTitle(newtitle);
	// widget.setHidden(true);
	widget.setGeometry1(100, 100, 300, 500);
	// widget.move_(400, 400);
	// widget.close();
	widget.repaint(());
	widget.repaint((0, 0, 100, 100));

	let mywidget = MyWidget::new();
	mywidget.show();
	mywidget.w.setVisible(true);

	let timer = QTimer::new();
	timer.setSingleShot(true);
	timer.timeout(|| {
		println!("Timeout!");
	});
	// timer.timeout(slot::QWidget::close(&widget));
	timer.start1(1000);

	unsafe { sys::qapplication_exec(app); }
	unsafe { sys::qapplication_delete(app); }
}
