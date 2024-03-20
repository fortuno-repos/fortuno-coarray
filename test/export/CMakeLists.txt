# This file is part of Fortuno.
# Licensed under the BSD-2-Clause Plus Patent license.
# SPDX-License-Identifier: BSD-2-Clause-Patent

cmake_minimum_required(VERSION 3.22...3.28)

project(
  FortunoCoarray_Test_Export
  VERSION 0.0.0
  DESCRIPTION "Testing the CMake build info exported by Fortuno"
  LANGUAGES Fortran
)

find_package(Fortuno REQUIRED)
find_package(FortunoCoarray REQUIRED)

add_subdirectory(app)
