get_filename_component(Boolector_DIR ${CMAKE_CURRENT_LIST_FILE} PATH)
set(Boolector_BIN_DIRS     ${Boolector_DIR}/bin )
set(Boolector_INCLUDE_DIRS ${Boolector_DIR}/include )
set(Boolector_INCLUDE_DIR  ${Boolector_INCLUDE_DIRS} )
set(Boolector_LIBRARIES    -lpthread ${Boolector_DIR}/lib/libboolector.a 
    ${Boolector_DIR}/lib/libbtor2parser.a ${Boolector_DIR}/lib/liblgl.a ${Boolector_DIR}/lib/libcadical.a)

set(Boolector_FOUND 1)
set(Boolector_VERSION 3.0.0)
