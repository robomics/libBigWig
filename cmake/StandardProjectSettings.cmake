# Set a default build type if none was specified
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Setting build type to 'RelWithDebInfo' as none was specified.")
  set(CMAKE_BUILD_TYPE
      RelWithDebInfo
      CACHE STRING "Choose the type of build." FORCE)
  # Set the possible values of build type for cmake-gui, ccmake
  set_property(
    CACHE CMAKE_BUILD_TYPE
    PROPERTY STRINGS
             "Debug"
             "Release"
             "MinSizeRel"
             "RelWithDebInfo")
endif()

string(TOUPPER "${CMAKE_BUILD_TYPE}" uppercase_CMAKE_BUILD_TYPE)

# Generate compile_commands.json to make it easier to work with clang based tools
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

option(BUILD_SHARED_LIBS "Enable compilation of shared libraries" OFF)
option(BUILD_DOCS "Build documentation using Doxygen" OFF)
option(ENABLE_TESTING "Enable unit tests" ON)

option(ENABLE_IPO "Enable Interprocedural Optimization, aka Link Time Optimization (LTO)" OFF)
option(ENABLE_PSO "Enable platform specific optimization" OFF)

option(WITH_CURL "Use CURL to support remote file access" ON)
option(CONAN_USE_LIBSTDC++11_ABI
       "Use C++11 ABI when compiling project dependencies with Conan. Set to off when compiling with GCC 5.0 and older"
       ON)

if(ENABLE_IPO)
  include(CheckIPOSupported)
  check_ipo_supported(RESULT result OUTPUT output)
  if(result)
    set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
  else()
    message(SEND_ERROR "IPO is not supported: ${output}")
  endif()
endif()

if(CONAN_USE_LIBSTDC++_ABI)
  set(CONAN_LIBCXX libstdc++11)
else()
  set(CONAN_LIBCXX libstdc++)
endif()
