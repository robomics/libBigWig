function(enable_doxygen)
  option(ENABLE_DOXYGEN "Enable doxygen doc builds of source" OFF)
  if(ENABLE_DOXYGEN)
    set(DOXYGEN_CALLER_GRAPH YES)
    set(DOXYGEN_CALL_GRAPH YES)
    set(DOXYGEN_CLASS_GRAPH YES)
    set(DOXYGEN_EXTRACT_ALL YES)
    set(DOXYGEN_EXTRACT_PRIVATE YES)
    set(DOXYGEN_HIDE_UNDOC_RELATIONS NO)
    set(DOXYGEN_NUM_PROC_THREADS 0)
    set(DOXYGEN_UML_LOOK YES)
    set(DOXYGEN_UML_LIMIT_NUM_FIELDS 50)
    set(DOXYGEN_TEMPLATE_RELATIONS YES)
    set(DOXYGEN_DOT_IMAGE_FORMAT "svg")
    set(DOXYGEN_INTERACTIVE_SVG YES)
    set(DOXYGEN_DOT_TRANSPARENT YES)
    set(DOXYGEN_DOT_GRAPH_MAX_NODES 100)
    set(DOXYGEN_QUIET YES)
    find_package(Doxygen REQUIRED dot)
    doxygen_add_docs(libbigwig_doxygen "${PROJECT_SOURCE_DIR}/src" COMMENT "Generate documentation")
  endif()
endfunction()
