# Do not edit this file, it is auto-generated!

# Generated by qrust-gen
# Generator: GModule
# Template:  cmakelists_txt.mako
# Timestamp: 2016-08-07T09:35:27Z

cmake_minimum_required(VERSION 3.1.0)

project(qrust-widgets-glue)

# set(CMAKE_CXX_STANDARD 11)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)

find_package(Qt5Core)
find_package(Qt5Widgets)

set(sources
	"qwidget.cpp"
)

add_library(qrust-widgets-glue STATIC ${sources})
target_link_libraries(qrust-widgets-glue Qt5::Core)
install(TARGETS qrust-widgets-glue ARCHIVE DESTINATION .)
