# MPI Example

This exercise is based on a fake analysis code that uses MPI to process some mock data. Whilst this
example is made up, it is not too far from a realistic analysis code. We will use this example to
learn how `mdb` can be used to debug MPI programs.

`mdb` provides a generic front-end for multiple backend debuggers e.g., `gdb`, `lldb`, `cuda-gdb`
and many others. We will use the `gdb` backend (which is the default choice) to build upon our
knowledge from the previous exercises.

We will see later that almost everything we have already learned can be almost immediately applied
in `mdb`.

The **main** thing you need to learn is how to switch from a serial-program mindset, to a
parralel-program mindset. That is, when debugging MPI programs, you need to think in MPI. Hopefully
the exercises below will make this clear.

> [!NOTE] When debugging MPI programs it is relatively easy to end up in infinite loops e.g.,
> waiting for processes to reach a breakpoint they can never reach, or leaving some processes
> blocked at `MPI_Barrier`s. Part of MPI debugging is learning to keep these kinds of situations in
> our minds, so that we can better use the debugger.

## Lesson Objectives

- [x] think in parralel when debugging MPI programs
- [x] `launch` and `attach` the `mdb` debugger
- [x] issue debug commands to the debugger backend using `command`
- [x] `select` which ranks you want to debug
- [x] use `broadcast` mode to interact directly with the backend
- [x] debug hanging programs using `backtrace`
- [x] `dump` memory from each process for post-processing


## Building

To build the C++/Fortran versions of the memory example, run:

```bash
make
```

This will compile the source files `analysis.cpp`/`analysis.f90` and produce the executables
`analysis-cpp.exe`/`analysis-f90.exe` respectively.

## Debugging

In this example I will focus on the Fortran example, but both codes are functionally the same. The
analysis code generates some fake data on each rank (in practice this would be read from a file).

```fortran
    ! generate fake input data (this would have been read from file normally)
    input_data = (/(rank * array_len + i, i = 1, array_len)/)
```

This data will then be processed on each rank separately

```fortran
    ! process data on each rank
    call process_partial_data(input_data)
```

Once it has been processed it will be gathered into a single array large enough to hold all of the
data `analysed_data`, assuming it passes a data integrity check (`data_integrity_check`).

```fortran
    ! only gather the data if it passes the integrity check
    call data_integrity_check(input_data, check)
    if (check > 0) then
      call MPI_Gather(input_data, array_len, MPI_INTEGER, analysed_data, array_len, MPI_INTEGER, 0, MPI_COMM_WORLD, ierr)
    end if
```

Lastly, we run a final processing stage on the full data `process_full_data` which only gets run on
rank 0.

```fortran
      call process_full_data(analysed_data)
```

Now we have an understanding of the code, lets try running it:

```bash
$ mpirun -n 4 ./analysis-f90.exe
```

> [!NOTE]
> This code is designed specifically to run on 4 processes, so it will only work when run with
> `mpirun -n 4`.

This will give something like the following

> [!NOTE]
> The order of the output will most likely be different to the one below. In general, MPI processes
> can run in any order and therefore the first one to write output can vary from run to run. Try
> running it a couple of times and see what happens.

```bash
$ mpirun -n 4 ./analysis-f90.exe
Process 3 input_data:  61,  62,  63,  64,  65,  66,  67,  68,  69,  70,  71,  72,  73,  74,  75, 76,  77,  78,  79,  80,
gathering data...
Process 0 input_data:   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,  15, 16,  17,  18,  19,  20,
gathering data...
Process 1 input_data:  21,  22,  23,  24,  25,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35, 36,  37,  38,  39,  40,
gathering data...
Process 2 input_data:  41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  52,  53,  54,  55, 56,  57,  58,  59,  60,
gathering data...
```

But then it appears to hang forever. Because this code is relatively small we would expect it to
execute almost immediately. So it appears there is something wrong. Let's use `mdb` to investigate
further. On your keyboard press `CTRL+C` in the terminal to terminate the `mpirun` command.



### Initial investigation

For a more detailed rundown of how `mdb` works, please see the tutorial in `mdb`'s
[documentation](https://mdb.readthedocs.io/en/latest/quick-start.html). We will cover the essential
instructions here.

### `launch`ing and `attach`ing `mdb`

`mdb` has a two stage run process. This is because it is designed to operate on HPC where we
typically run our job on a compute node, but then connect to it from a login node. However, it also
works perfectly find when run on the same machine, which is what we will do here. There are
different ways to do this, but I find the easiest is to split the terminal. You can split the VSCode
terminal by clicking the split terminal button, or using the keyboard shortcut `CTRL+SHIFT+5`.

In one terminal (doesn't matter which) type the `launch` command. You should see the following

```bash
$ mdb launch -n 4 -t analysis-f90.exe -p 3000
running on host: 127.0.0.1
to connect to the debugger run:
mdb attach -h 127.0.0.1 -p 3000

connecting to debuggers ... (4/4)
all debug clients connected
```

Horay! :tada: The program is now running successfully.

### Putting it all together

- [ ] try running the `run` command once you have already started a 

> [!NOTE]
> One interesting point of this exercise is it helps us to track down a memory error that
> even `valgrind` and memory santizers won't detect. For some use cases a debugger may be your only
> option.
