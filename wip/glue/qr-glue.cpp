#include <iostream>

#include <QtWidgets/QApplication>

using std::cout;
using std::endl;


static int argc = 1;
static char *args[] = { "qr", NULL };

extern "C" void* qapplication_create() {
	return new QApplication(argc, args);
}

extern "C" void qapplication_exec(const void* self) {
	auto app = static_cast<const QApplication*>(self);
	app->exec();
}

extern "C" void qapplication_delete(const void* self) {
	auto app = static_cast<const QApplication*>(self);
	delete app;
}
