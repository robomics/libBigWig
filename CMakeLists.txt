cmake_minimum_required(VERSION 3.11)

project(
  libBigWig
  LANGUAGES C
  VERSION 0.4.6
  DESCRIPTION "A C library for handling bigWig files")

include(cmake/StandardProjectSettings.cmake)
include(cmake/PreventInSourceBuilds.cmake)

# Link this 'library' to set the c++ standard / compile-time options requested
add_library(libbigwig_project_options INTERFACE)

# Link this 'library' to use the warnings specified in CompilerWarnings.cmake
add_library(libbigwig_project_warnings INTERFACE)

if(CMAKE_C_COMPILER_ID MATCHES ".*Clang")
  option(ENABLE_BUILD_WITH_TIME_TRACE "Enable -ftime-trace to generate time tracing .json files on clang" OFF)
  if(ENABLE_BUILD_WITH_TIME_TRACE)
    add_compile_definitions(libbigwig_project_options INTERFACE -ftime-trace)
  endif()
endif()

# standard compiler warnings
include(cmake/CompilerWarnings.cmake)
set_project_warnings(libbigwig_project_warnings)

# sanitizer options if supported by compiler
include(cmake/Sanitizers.cmake)
enable_sanitizers(libbigwig_project_options)

# enable doxygen
include(cmake/Doxygen.cmake)
enable_doxygen()

# allow for static analysis options
include(cmake/StaticAnalyzers.cmake)

if(USE_CONAN)
  include(cmake/Conan.cmake)
  run_conan()
else()
  find_package(ZLIB REQUIRED)
  if(WITH_CURL)
    find_package(CURL REQUIRED)
  endif()
endif()

add_subdirectory(src)

if (ENABLE_TESTING)
  add_subdirectory(test)
endif()
