program play
    implicit none

    integer :: i
    integer, dimension(10) :: data
    integer :: int_var
    real :: real_var
    double precision :: double_var
    logical :: logical_var

    ! Populate the array with values from 1 to 10
    do i = 1, 10
        data(i) = i
    end do

    ! Assign values to variables
    int_var = 5
    real_var = 3.14
    double_var = 2.718281828459045d0
    logical_var = .true.

    call multiply_by_two(int_var)

    ! Check the logical variable and print if true
    if (logical_var) then
        print *, 'The logical variable is true.'
    end if

    ! Print all variables
    print *, 'Data array: ', data
    print *, 'Integer variable: ', int_var
    print *, 'Real variable: ', real_var
    print *, 'Double precision variable: ', double_var
    print *, 'logical variable: ', logical_var

    contains

    subroutine multiply_by_two(var)
        integer, intent(inout) :: var

        var = 2 * var
    end subroutine multiply_by_two

end program play
