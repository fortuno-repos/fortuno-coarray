# This file is part of Fortuno.
# Licensed under the BSD-2-Clause Plus Patent license.
# SPDX-License-Identifier: BSD-2-Clause-Patent

# Folder for generated mod-files
set(moduledir "${CMAKE_CURRENT_BINARY_DIR}/mods")

add_library(fortuno_coarray)
set_target_properties(
  fortuno_coarray
  PROPERTIES
    VERSION ${PROJECT_VERSION}
    # TODO: change to ${PROJECT_VERSION_MAJOR} once project version reaches 1.0
    SOVERSION ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    EXPORT_NAME fortuno_coarray
    OUTPUT_NAME fortuno-coarray
    Fortran_MODULE_DIRECTORY "${moduledir}"
)
target_link_libraries(fortuno_coarray PRIVATE CoarrayBuild)
target_link_libraries(fortuno_coarray PUBLIC Fortuno::fortuno)
target_include_directories(
  fortuno_coarray PUBLIC
  $<BUILD_INTERFACE:${moduledir}>
  $<INSTALL_INTERFACE:${CMAKE_INSTALL_LIBDIR}/${FORTUNO_COARRAY_INSTALL_MODULEDIR}>
)
target_sources(fortuno_coarray PRIVATE fortuno_coarray.f90)
add_subdirectory(fortuno_coarray)

add_library(Fortuno::fortuno_coarray ALIAS fortuno_coarray)

if (FORTUNO_COA_INSTALL)
  install(
    TARGETS fortuno_coarray
    EXPORT FortunoCoarrayTargets
    LIBRARY
      DESTINATION "${CMAKE_INSTALL_LIBDIR}"
      COMPONENT FortunoCoarray_runtime
      NAMELINK_COMPONENT FortunoCoarray_development
    PUBLIC_HEADER
      DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
      COMPONENT FortunoCoarray_development
  )
  install(
    DIRECTORY "${moduledir}/"
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/${FORTUNO_COA_INSTALL_MODULEDIR}"
    COMPONENT FortunoCoarray_development
  )
endif ()
