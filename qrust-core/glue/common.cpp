#include <iostream>

#include "common.h"


extern "C" int connection_disconnect(void* obj)
{
	auto con = static_cast<Connection*>(obj);
	bool ret = con->disconnect();
	if (ret) {
		delete con;
	}
	return ret;
}
