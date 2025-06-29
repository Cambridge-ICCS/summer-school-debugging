program analysis
  use mpi

  implicit none

  integer :: rank
  integer, parameter :: array_len = 20, total_len = 80

  call main()

contains

  ! main program
  subroutine main()

    implicit none

    integer :: ierr, size, i
    integer :: input_data(array_len)
    integer, allocatable :: analysed_data(:)

    integer :: check = 0

    ! Initialize the MPI environment
    call MPI_Init(ierr)
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, size, ierr)

    if (rank == 0) then
      allocate(analysed_data(total_len))
    end if

    ! Ensure the program is running with exactly 4 processes
    if (size /= 4) then
      if (rank == 0) print *, 'This program requires exactly 4 processes.'
      call MPI_Abort(MPI_COMM_WORLD, 1, ierr)
    end if

    ! generate fake input data (this would have been read from file normally)
    input_data = (/(rank * array_len + i, i = 1, array_len)/)
    print '("Process ", i1, " input_data:", 20(i4, ","))', rank, input_data
    call flush()

    ! process data on each rank
    call process_partial_data(input_data)

    ! only gather the data if it passes the integrity check
    print *, "gathering data..."
    call flush()
    call data_integrity_check(input_data, check)
    if (check > 0) then
      call MPI_Gather(input_data, array_len, MPI_INTEGER, analysed_data, array_len, MPI_INTEGER, 0, MPI_COMM_WORLD, ierr)
    end if

    call MPI_Barrier(MPI_COMM_WORLD, ierr)
    print '("Process ", i1, " data gathered")', rank
    call flush()

    if (rank == 0) then
      print *, "processing final array..."
      call flush()

      call process_full_data(analysed_data)

      print *, "Processed data :: "
      print '(80(i3, ","))', analysed_data
      call flush()

      ! clean up allocatable array
      deallocate(analysed_data)
    end if

    ! Finalize the MPI environment
    call MPI_Finalize(ierr)

  end subroutine main

  ! check the integrity of the analysis data
  ! if any values are zero we return check = 0
  subroutine data_integrity_check(data, check)
    implicit none

    integer, intent(in)  :: data(:)
    integer, intent(out) :: check
    integer :: i

    check = 1
    do i = 1, array_len
      if (data(i) == 0) then
        check = 0
      end if
    end do
  end subroutine data_integrity_check

  ! pretend to process the input_data on each rank
  subroutine process_partial_data(data)
    implicit none

    integer, intent(inout) :: data(:)
    integer :: i

    ! fake data processing
    do i = 1, array_len
      data(i) = int(10*(sin(i*0.5)+2.0)) + data(i)
    end do

    ! fake some erroneous data
    if (rank == 3) then
      data(3) = 0
    end if
  end subroutine process_partial_data

  ! pretend to process the gathered data
  subroutine process_full_data(data)
    implicit none

    integer, intent(inout) :: data(:)
    integer :: i

    do i = 1, total_len
      data(i) = 1024 / data(i)
    end do

  end subroutine process_full_data

end program analysis
