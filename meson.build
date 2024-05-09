# This file is part of Fortuno.
# Licensed under the BSD-2-Clause Plus Patent license.
# SPDX-License-Identifier: BSD-2-Clause-Patent

project(
  'fortuno-coarray',
  'fortran',
  version: '0.1.0',
)

coarray_compile_flags = get_option('coarray_compile_flags')
coarray_link_flags = get_option('coarray_link_flags')

fortuno_coarray_deps = []

# Disabling coarray detection as it seems to be fragile. Make sure to pass the right coarray
# compiler and linker arguments via the "coarray_compile_flags" and "coarray_link_flags" build variables.
# coarray_dep = dependency('coarray')
# fortuno_coarray_deps += coarray_dep

fortuno_dep = dependency(
  'fortuno',
  fallback: ['fortuno', 'fortuno_dep'],
  default_options: {
    'build_serial_interface': false,
    'thread_safe_flags': coarray_compile_flags,
    'thread_safe_link_flags': coarray_link_flags
  },
)
fortuno_coarray_deps += fortuno_dep

fortuno_coarray_srcs = []
subdir('src')

fortuno_coarray_lib = library(
  meson.project_name(),
  version: meson.project_version(),
  sources: fortuno_coarray_srcs,
  dependencies: fortuno_coarray_deps,
  fortran_args: coarray_compile_flags,
  link_args: coarray_link_flags,
)

fortuno_coarray_dep = declare_dependency(
  link_with: fortuno_coarray_lib,
  dependencies: fortuno_coarray_deps,
)

build_examples = get_option('build_examples')
if build_examples
  subdir('example')
endif
