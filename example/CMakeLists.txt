# This file is part of Fortuno.
# Licensed under the BSD-2-Clause Plus Patent license.
# SPDX-License-Identifier: BSD-2-Clause-Patent

list(APPEND CMAKE_MESSAGE_CONTEXT Example)

add_library(FortunoCoarray_example_mylib)
set_target_properties(
  FortunoCoarray_example_mylib PROPERTIES
  OUTPUT_NAME mylib
)
target_sources(
  FortunoCoarray_example_mylib PRIVATE
  mylib.f90
)
target_link_libraries(FortunoCoarray_example_mylib PRIVATE CoarrayBuild)

add_executable(FortunoCoarray_example_testapp)
set_target_properties(
  FortunoCoarray_example_testapp PROPERTIES
  OUTPUT_NAME testapp
)
target_sources(
  FortunoCoarray_example_testapp PRIVATE
  simple_tests.f90
  testapp.f90
)
target_link_libraries(
  FortunoCoarray_example_testapp PRIVATE
  FortunoCoarray_example_mylib Fortuno::fortuno_coarray CoarrayBuild
)
