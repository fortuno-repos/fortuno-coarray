! This file is part of Fortuno.
! Licensed under the BSD-2-Clause Plus Patent license.
! SPDX-License-Identifier: BSD-2-Clause-Patent

!> Test app driving Fortuno unit tests
program testapp
  use fortuno_coarray, only : context => coa_context, test => coa_pure_case_item,&
      & execute_coa_cmd_app, is_equal
  implicit none

  call execute_coa_cmd_app(&
      testitems=[&
          test("success", test_success)&
      ]&
  )

contains

  subroutine test_success(ctx)
    class(context), intent(inout) :: ctx

    integer :: buffer

    buffer = 0
    if (this_image() == 1) buffer = 1
    call co_broadcast(buffer, 1)
    call ctx%check(is_equal(buffer, 1))

  end subroutine test_success

end program testapp
