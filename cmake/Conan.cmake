macro(run_conan)
  # Source: https://raw.githubusercontent.com/conan-io/cmake-conan/v0.16.1/conan.cmake
  include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/conan-v0.16.1.cmake)

  conan_add_remote(
    NAME
    conan-center
    URL
    https://center.conan.io)

  set(CONAN_SETTINGS "")
  if(CMAKE_C_COMPILER_ID STREQUAL AppleClang
     OR CMAKE_C_COMPILER_ID STREQUAL Clang
     OR CMAKE_C_COMPILER_ID STREQUAL GNU)
    set(CONAN_SETTINGS ${CONAN_SETTINGS} compiler.libcxx=${CONAN_LIBCXX})
  endif()

  conan_cmake_run(
    CONANFILE
    conanfile.py
    SETTINGS
    ${CONAN_SETTINGS}
    OPTIONS
    with_curl=${WITH_CURL}
    ENV
    "CC=${CMAKE_C_COMPILER}"
    "CXX=${CMAKE_CXX_COMPILER}"
    BASIC_SETUP
    CMAKE_TARGETS # individual targets to link to
    BUILD
    outdated
    PROFILE_AUTO
    ALL)
endmacro()
