#----------------------------------------------------------------
# Generated CMake target import file for configuration "Debug".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "LSL::lsl" for configuration "Debug"
set_property(TARGET LSL::lsl APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(LSL::lsl PROPERTIES
  IMPORTED_IMPLIB_DEBUG "${_IMPORT_PREFIX}/lib/liblsl64.lib"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/bin/liblsl64.dll"
  )

list(APPEND _IMPORT_CHECK_TARGETS LSL::lsl )
list(APPEND _IMPORT_CHECK_FILES_FOR_LSL::lsl "${_IMPORT_PREFIX}/lib/liblsl64.lib" "${_IMPORT_PREFIX}/bin/liblsl64.dll" )

# Import target "LSL::lslver" for configuration "Debug"
set_property(TARGET LSL::lslver APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(LSL::lslver PROPERTIES
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/bin/lslver.exe"
  )

list(APPEND _IMPORT_CHECK_TARGETS LSL::lslver )
list(APPEND _IMPORT_CHECK_FILES_FOR_LSL::lslver "${_IMPORT_PREFIX}/bin/lslver.exe" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
