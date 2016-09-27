${header("#")}
## In Mako, "$" has to be escaped as "$${}" :-/
cmake_minimum_required(VERSION 3.1.0)

project(${lib})

# set(CMAKE_CXX_STANDARD 11)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)

% for d in deps:
find_package(${d.pkgname})
% endfor
find_package(${pkgname})

set(sources
% for cpp in cppfiles:
	"${cpp}"
% endfor
)

add_library(${lib} STATIC $${}{sources})
target_link_libraries(${lib} Qt5::Core)
install(TARGETS ${lib} ARCHIVE DESTINATION .)
