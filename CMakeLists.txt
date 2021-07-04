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

add_library(libBigWig)
add_library(libBigWig::libbigwig ALIAS libBigWig)

target_sources(
  libBigWig
  PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src/bwRead.c
          ${CMAKE_CURRENT_SOURCE_DIR}/src/bwStats.c
          ${CMAKE_CURRENT_SOURCE_DIR}/src/bwValues.c
          ${CMAKE_CURRENT_SOURCE_DIR}/src/bwWrite.c
          ${CMAKE_CURRENT_SOURCE_DIR}/src/io.c)

target_include_directories(libBigWig PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

# cmake-format: off
target_link_libraries(
  libBigWig
  PRIVATE libbigwig_project_options
  PUBLIC $<$<AND:$<BOOL:${USE_CONAN}>,$<BOOL:${WITH_CURL}>>:CONAN_PKG::libcurl>
         $<$<AND:$<NOT:$<BOOL:${USE_CONAN}>>,$<BOOL:${WITH_CURL}>>:CURL::libcurl>
         $<IF:$<BOOL:${USE_CONAN}>,CONAN_PKG::zlib,ZLIB::ZLIB>
         m) # -lm
# cmake-format: on

if(NOT WITH_CURL)
  target_compile_definitions(libBigWig PUBLIC -DNOCURL)
endif()

target_compile_features(libBigWig PRIVATE c_std_99)
set_target_properties(libBigWig PROPERTIES OUTPUT_NAME BigWig)

add_subdirectory(test)

install(
  TARGETS libBigWig
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  RUNTIME DESTINATION bin
  INCLUDES
  DESTINATION include)
