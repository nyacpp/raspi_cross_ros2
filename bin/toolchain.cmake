set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_LIBRARY_ARCHITECTURE arm-linux-gnueabihf)
set(CMAKE_CROSSCOMPILING_EMULATOR /usr/bin/qemu-arm-static)
set(CMAKE_C_COMPILER /cross/bin/arm-linux-gnueabihf-gcc)
set(CMAKE_CXX_COMPILER /cross/bin/arm-linux-gnueabihf-g++)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_SYSROOT /raspi CACHE PATH "")

set(BUILD_TESTING OFF CACHE STRING "")  # turn off ROS tests
set(PYTHON_SOABI cpython-39-arm-linux-gnueabihf CACHE STRING "")  # python: sysconfig.get_config_var('SOABI')
set(PYTHON_MODULE_EXTENSION .${PYTHON_SOABI}.so CACHE STRING "")  # _rclpy_pybind11 suffix

# Some of ROS2 nodes do not accept CMAKE_TOOLCHAIN_FILE argument,
# so the workaround is to use only C/CXX_FLAGS.
set(c_flags
		-isystem ${CMAKE_SYSROOT}/usr/include/arm-linux-gnueabihf
		-isystem ${CMAKE_SYSROOT}/usr/include
		-L${CMAKE_SYSROOT}/usr/lib
		-L${CMAKE_SYSROOT}/usr/lib/arm-linux-gnueabihf
		-L${CMAKE_SYSROOT}/usr/lib/gcc/arm-linux-gnueabihf/10
		-Wl,-rpath-link,${CMAKE_SYSROOT}/usr/lib
		-Wl,-rpath-link,${CMAKE_SYSROOT}/usr/lib/arm-linux-gnueabihf
		-Wl,-rpath-link,${CMAKE_SYSROOT}/usr/lib/gcc/arm-linux-gnueabihf/10
)
string(REPLACE ";" " " c_flags_string "${c_flags}")
string(APPEND CMAKE_C_FLAGS_INIT " ${c_flags_string}")

set(cxx_flags
		-isystem ${CMAKE_SYSROOT}/usr/include/arm-linux-gnueabihf/c++/10
		-isystem ${CMAKE_SYSROOT}/usr/include/c++/10
		${c_flags}
)
string(REPLACE ";" " " cxx_flags_string "${cxx_flags}")
string(APPEND CMAKE_CXX_FLAGS_INIT " ${cxx_flags_string}")

string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT " -latomic")
string(APPEND CMAKE_SHARED_LINKER_FLAGS_INIT " -latomic")
#
# -latomic fixes librclcpp.so: undefined reference to `__atomic_fetch_add_8'
#     possible issue: https://github.com/eProsima/Fast-DDS/issues/1262
#
