cmake_minimum_required(VERSION 3.8)

project(helios-base VERSION 2023.03)

if(CMAKE_VERSION VERSION_LESS "3.7.0")
    set(CMAKE_INCLUDE_CURRENT_DIR ON)
endif()

# compliler options
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING "" FORCE)
endif()
set(CMAKE_CXX_FLAGS "-W -Wall")




list(APPEND CMAKE_PREFIX_PATH "${GRPC_LIB_PATH}")
set(LIBRARY_PATH "${GRPC_LIB_PATH}/lib")
link_directories(${LIBRARY_PATH})

find_package(absl CONFIG REQUIRED)
find_package(Protobuf CONFIG REQUIRED)
find_package(gRPC CONFIG REQUIRED)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -I${Protobuf_INCLUDE_DIRS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -I${gRPC_INCLUDE_DIRS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -I${absl_INCLUDE_DIRS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -I${GRPC_LIB_PATH}/include")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -L${GRPC_LIB_PATH}/lib")


set(PROTO_FILES
    grpc/protos/service.proto
)


# check librcsc
set(LIBRCSC_INSTALL_DIR "$ENV{RCSC_LIB_PATH};$ENV{HOME}/.local;$ENV{HOME}/local;/usr/local/lib" CACHE PATH "The path where librcsc is installed.")

find_library(LIBRCSC_LIB NAMES rcsc
  PATHS ${LIBRCSC_INSTALL_DIR}
  PATH_SUFFIXES lib
  )
if(NOT LIBRCSC_LIB)
  message(FATAL_ERROR "librcsc library not found!")
endif()
get_filename_component(LIBRCSC_LIBDIR ${LIBRCSC_LIB} DIRECTORY)

find_path(LIBRCSC_INCLUDE_DIR
  NAME rcsc/types.h
  PATHS ${LIBRCSC_INSTALL_DIR}
  PATH_SUFFIXES include
  )
if(NOT LIBRCSC_INCLUDE_DIR)
  message(FATAL_ERROR "librcsc include dir not found!")
endif()

# remove variables from GUI
mark_as_advanced(
  LIBRCSC_LIB
  LIBRCSC_INCLUDE_DIR
  LIBRCSC_LIBDIR
  )

# boost
find_package(Boost 1.36.0 COMPONENTS system REQUIRED)
if(NOT Boost_FOUND)
  message(FATAL_ERROR "Boost not found!")
endif()

# zlib
find_package(ZLIB)
if(ZLIB_FOUND)
  set(HAVE_LIBZ TRUE)
endif()

# generate config.h
add_definitions(-DHAVE_CONFIG_H)
configure_file(
  ${PROJECT_SOURCE_DIR}/cmake-config.h.in
  ${PROJECT_BINARY_DIR}/config.h
  )

# check the settings
message(STATUS "Found librcsc:")
message(STATUS "  LIBRCSC_LIBDIR=${LIBRCSC_LIBDIR}")
message(STATUS "  LIBRCSC_LIB=${LIBRCSC_LIB}")
message(STATUS "  LIBRCSC_INCLUDE_DIR=${LIBRCSC_INCLUDE_DIR}")
message(STATUS "Build settings:")
message(STATUS "  BUILD_TYPE=${CMAKE_BUILD_TYPE}")
message(STATUS "Found Protobuf:")
message(STATUS "  Protobuf_INCLUDE_DIRS=${Protobuf_INCLUDE_DIRS}")
message(STATUS "  Protobuf_LIBRARIES=${Protobuf_LIBRARIES}")
message(STATUS "  Protobuf_PROTOC_EXECUTABLE=${Protobuf_PROTOC_EXECUTABLE}")
message(STATUS "  Protobuf_VERSION=${Protobuf_VERSION}")
message(STATUS "Found gRPC:")
message(STATUS "  gRPC_INCLUDE_DIRS=${gRPC_INCLUDE_DIRS}")
message(STATUS "  gRPC_LIBRARIES=${gRPC_LIBRARIES}")
message(STATUS "  gRPC_VERSION=${gRPC_VERSION}")
message(STATUS "Found absl:")
message(STATUS "  absl_INCLUDE_DIRS=${absl_INCLUDE_DIRS}")
message(STATUS "  absl_LIBRARIES=${absl_LIBRARIES}")
message(STATUS "  absl_VERSION=${absl_VERSION}")

# sub directories
add_subdirectory(src)


include_directories("${GRPC_LIB_PATH}/include/google/protobuf")
add_definitions("${GRPC_LIB_PATH}/include/google/protobuf")