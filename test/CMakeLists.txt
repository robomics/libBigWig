add_executable(exampleWrite exampleWrite.c)
add_executable(testBigBed testBigBed.c)
add_executable(testIterator testIterator.c)
add_executable(testLocal testLocal.c)
add_executable(testWrite testWrite.c)

target_link_libraries(exampleWrite PRIVATE project_options libBigWig::libbigwig)
target_link_libraries(testBigBed PRIVATE project_options libBigWig::libbigwig)
target_link_libraries(testIterator PRIVATE project_options libBigWig::libbigwig)
target_link_libraries(testLocal PRIVATE project_options libBigWig::libbigwig)
target_link_libraries(testWrite PRIVATE project_options libBigWig::libbigwig)

if(WITH_CURL)
  add_executable(testRemote testRemote.c)
  add_executable(testRemoteManyContigs testRemoteManyContigs.c)

  target_link_libraries(testRemote PRIVATE project_options libBigWig::libbigwig)
  target_link_libraries(testRemoteManyContigs PRIVATE project_options libBigWig::libbigwig)
endif()
