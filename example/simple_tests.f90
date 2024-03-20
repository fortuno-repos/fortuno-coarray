! This file is part of Fortuno.
! Licensed under the BSD-2-Clause Plus Patent license.
! SPDX-License-Identifier: BSD-2-Clause-Patent

module simple_tests
  use mylib, only : broadcast
  use fortuno_coarray, only : as_char, test => coa_pure_case_item, context => coa_context,&
      & is_equal, test_item
  implicit none

  private
  public :: get_simple_tests

contains

  ! Returns the tests from this module
  function get_simple_tests() result(testitems)
    type(test_item), allocatable :: testitems(:)

    testitems = [&
        test("broadcast", test_broadcast) &
    ]

  end function get_simple_tests


  subroutine test_broadcast(ctx)
    class(context), intent(inout) :: ctx

    integer, parameter :: sourceimg = 1, sourceval = 100, otherval = -1
    integer :: buffer

    character(:), allocatable :: msg

    ! GIVEN source rank contains a different integer value as all other ranks
    if (this_image() == sourceimg) then
      buffer = sourceval
    else
      buffer = otherval
    end if

    ! WHEN source rank broadcasts its value
    call broadcast(buffer, sourceimg)

    ! Make every third rank fail for demonstration purposes
    if (mod(this_image() - 1, 3) == 2) then
      buffer = sourceval + 1
      msg = "Failing on image " //  as_char(this_image()) // " on purpose"
    end if

    ! THEN each rank must contain source rank's value
    call ctx%check(is_equal(buffer, sourceval), msg=msg)

  end subroutine test_broadcast

end module simple_tests
