# Variables influencing how subproject is obtained
set(CMAKE_REQUIRE_FIND_PACKAGE_Fortuno ${FORTUNO_COA_SUBPROJECT_REQUIRE_FIND})
set(CMAKE_DISABLE_FIND_PACKAGE_Fortuno ${FORTUNO_COA_SUBPROJECT_DISABLE_FIND})
# set FETCHCONTENT_SOURCE_DIR_FORTUNO to use a local source of the subproject

# Subproject related variables
set(FORTUNO_INSTALL ${FORTUNO_COA_INSTALL})
set(FORTUNO_INSTALL_MODULEDIR ${FORTUNO_COA_INSTALL_MODULEDIR})
set(FORTUNO_BUILD_SHARED_LIBS ${FORTUNO_COA_BUILD_SHARED_LIBS})
set(FORTUNO_BUILD_SERIAL_INTERFACE OFF)

FetchContent_Declare(
  Fortuno
  GIT_REPOSITORY "https://github.com/fortuno-repos/fortuno.git"
  GIT_TAG "main"
  FIND_PACKAGE_ARGS
)
FetchContent_MakeAvailable(Fortuno)

if (Fortuno_FOUND)
  message(STATUS "Subproject Fortuno: using installed version")
else ()
  message(STATUS "Subproject Fortuno: building from source in ${fortuno_SOURCE_DIR}")
endif ()
