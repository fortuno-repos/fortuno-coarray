# This file is part of Fortuno.
# Licensed under the BSD-2-Clause Plus Patent license.
# SPDX-License-Identifier: BSD-2-Clause-Patent

# Sets up the build type.
function (fortuno_coa_setup_build_type default_build_type)

  get_property(_multiConfig GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
  if(_multiConfig)
    message(STATUS "Build type multi-config (build type selected at the build step)")
  else()
    if(NOT CMAKE_BUILD_TYPE)
      message(STATUS "Build type ${default_build_type} (default single-config)")
      set(CMAKE_BUILD_TYPE "${default_build_type}" CACHE STRING "Build type" FORCE)
      set_property(CACHE CMAKE_BUILD_TYPE PROPERTY HELPSTRING "Choose the type of build")
      set_property(
        CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "RelWithDebInfo"
      )
    else()
      message(STATUS "Build type ${CMAKE_BUILD_TYPE} (manually selected single-config)")
    endif()
  endif()

endfunction ()


# Defines the coarray target for coarray dependent parts
function (fortuno_coa_def_coarray_build_target)

  if (FORTUNO_COA_COARRAY_FLAGS)
    set(_compiler_flags "${FORTUNO_COA_COARRAY_FLAGS}")
  elseif (CMAKE_Fortran_COMPILER_ID STREQUAL "IntelLLVM")
    set(_compiler_flags "-coarray")
  elseif (CMAKE_Fortran_COMPILER_ID STREQUAL "NAG")
    set(_compiler_flags "-coarray")
  endif ()

  if (FORTUNO_COA_COARRAY_LINK_FLAGS)
    set(_linker_flags "${FORTUNO_COA_COARRAY_LINK_FLAGS}")
  elseif (CMAKE_Fortran_COMPILER_ID STREQUAL "IntelLLVM")
    set(_linker_flags "-coarray")
  elseif (CMAKE_Fortran_COMPILER_ID STREQUAL "NAG")
    set(_linker_flags "-coarray")
  endif ()

  add_library(CoarrayBuild INTERFACE)
  target_compile_options(CoarrayBuild INTERFACE ${_compiler_flags})
  target_link_options(CoarrayBuild INTERFACE ${_linker_flags})

endfunction ()