find_package(CURL REQUIRED)
find_package(ZLIB REQUIRED)

add_library(libBigWig)
add_library(libBigWig::libbigwig ALIAS libBigWig)

target_sources(
  libBigWig
  PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/bwRead.c
          ${CMAKE_CURRENT_SOURCE_DIR}/bwStats.c
          ${CMAKE_CURRENT_SOURCE_DIR}/bwValues.c
          ${CMAKE_CURRENT_SOURCE_DIR}/bwWrite.c
          ${CMAKE_CURRENT_SOURCE_DIR}/io.c)

target_include_directories(libBigWig PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

target_link_libraries(
  libBigWig
  PRIVATE libbigwig_project_options
  PUBLIC $<$<BOOL:${WITH_CURL}>:CURL::libcurl> ZLIB::ZLIB $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:m>) # -lm

if(NOT WITH_CURL)
  target_compile_definitions(libBigWig PUBLIC -DNOCURL)
endif()

target_compile_features(libBigWig PRIVATE c_std_99)
set_target_properties(libBigWig PROPERTIES OUTPUT_NAME BigWig)

install(
  TARGETS libBigWig
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  RUNTIME DESTINATION bin
  INCLUDES
  DESTINATION src/include)
