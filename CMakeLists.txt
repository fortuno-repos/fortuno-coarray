# This file is part of Fortuno.
# Licensed under the BSD-2-Clause Plus Patent license.
# SPDX-License-Identifier: BSD-2-Clause-Patent

#[=================================================================================================[
#                                 Basic project definition                                        #
]=================================================================================================]

cmake_minimum_required(VERSION 3.22...3.28)

list(APPEND CMAKE_MESSAGE_CONTEXT FortunoCoarray)
project(
  FortunoCoarray
  VERSION 0.1.0
  DESCRIPTION "Extensible unit testing framework for Fortran (coarray dependent part)"
  HOMEPAGE_URL "https://github.com/fortuno-repos/fortuno-coarray"
  LANGUAGES Fortran
)

#[=================================================================================================[
#                                 Options                                                         #
]=================================================================================================]

include(CMakeDependentOption)

option(FORTUNO_COA_BUILD_SHARED_LIBS "Fortuno: Build as shared library" ${PROJECT_IS_TOP_LEVEL})

option(FORTUNO_COA_BUILD_TESTS "Fortuno: Build test suite" ${PROJECT_IS_TOP_LEVEL})

option(FORTUNO_COA_BUILD_EXAMPLES "Fortuno: Build example apps" ${PROJECT_IS_TOP_LEVEL})

option(FORTUNO_COA_INSTALL "Fortuno: Install project" ${PROJECT_IS_TOP_LEVEL})

set(
  FORTUNO_COA_INSTALL_MODULEDIR "modules" CACHE STRING
  "Fortuno: Sub-directory to install the Fortran module files into (relative to CMAKE_INSTALL_LIBDIR)"
)

set(FORTUNO_COA_COARRAY_COMPILE_FLAGS "" CACHE STRING "Fortuno: Flags to use when compiling coarray source")

set(
  FORTUNO_COA_COARRAY_LINK_FLAGS "" CACHE STRING
  "Fortuno: Flags to use when linking coarray object files"
)

option(
  FORTUNO_COA_SUBPROJECT_REQUIRE_FIND
  "Fortuno: Whether all subprojects should be obtained by the find method (e.g. for packaging)"
  OFF
)

option(
  FORTUNO_COA_SUBPROJECT_DISABLE_FIND
  "Fortuno: Whether none of the subprojects should be obtained by the find method"
  OFF
)

#[=================================================================================================[
#                            Project configuration                                                #
]=================================================================================================]

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)
include(FortunoCoarrayHelpers)

if (FORTUNO_COA_INSTALL)
  include(CMakePackageConfigHelpers)
  include(GNUInstallDirs)
endif ()

set(BUILD_SHARED_LIBS ${FORTUNO_COA_BUILD_SHARED_LIBS})
fortuno_coa_setup_build_type("RelWithDebInfo")
fortuno_coa_def_coarray_build_target()


#[=================================================================================================[
#                                 Main definition                                                 #
]=================================================================================================]

include(FetchContent)
include(subprojects/fortuno.cmake)

add_subdirectory(src)
if (FORTUNO_COA_BUILD_EXAMPLES)
  add_subdirectory(example)
endif ()

#[=================================================================================================[
#                                 Install or Export                                               #
]=================================================================================================]

if (FORTUNO_COA_INSTALL)

  # pkg-config files
  configure_file(cmake/fortuno-coarray.pc.in fortuno-coarray.pc @ONLY)
  install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/fortuno-coarray.pc
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig
    COMPONENT FortunoCoarray_development
  )

  # cmake export files
  write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/FortunoCoarrayConfigVersion.cmake
    VERSION ${PROJECT_VERSION}
    # TODO: Switch to SameMajorVersion as soon as project version reaches 1.0.
    COMPATIBILITY SameMinorVersion
  )
  configure_package_config_file(
      cmake/FortunoCoarrayConfig.cmake.in
      ${CMAKE_CURRENT_BINARY_DIR}/FortunoCoarrayConfig.cmake
      INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/FortunoCoarray
  )
  install(
    FILES
      ${CMAKE_CURRENT_BINARY_DIR}/FortunoCoarrayConfigVersion.cmake
      ${CMAKE_CURRENT_BINARY_DIR}/FortunoCoarrayConfig.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/FortunoCoarray
    COMPONENT FortunoCoarray_development
  )

  export(
    EXPORT FortunoCoarrayTargets
    FILE FortunoCoarrayTargets.cmake
    NAMESPACE Fortuno::
  )
  install(
    EXPORT FortunoCoarrayTargets
    FILE FortunoCoarrayTargets.cmake
    NAMESPACE Fortuno::
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/FortunoCoarray
    COMPONENT FortunoCoarray_development
  )
endif ()

# Make project available for FetchContent
if (NOT PROJECT_IS_TOP_LEVEL)
  # Propagate variables
  if (CMAKE_VERSION VERSION_LESS 3.25)
    # TODO: Remove when required minimum cmake version is >= 3.25
    set(FortunoCoarray_VERSION ${FortunoCoarray_VERSION} PARENT_SCOPE)
    set(FortunoCoarray_VERSION_MAJOR ${FortunoCoarray_VERSION_MAJOR} PARENT_SCOPE)
    set(FortunoCoarray_VERSION_MINOR ${FortunoCoarray_VERSION_MINOR} PARENT_SCOPE)
    set(FortunoCoarray_VERSION_PATCH ${FortunoCoarray_VERSION_PATCH} PARENT_SCOPE)
    set(FortunoCoarray_VERSION_TWEAK ${FortunoCoarray_VERSION_TWEAK} PARENT_SCOPE)
  else ()
    return(
      PROPAGATE
      FortunoCoarray_VERSION
      FortunoCoarray_VERSION_MAJOR
      FortunoCoarray_VERSION_MINOR
      FortunoCoarray_VERSION_PATCH
      FortunoCoarray_VERSION_TWEAK
    )
  endif ()
endif ()
