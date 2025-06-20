# Memory Example

This directory contains a toy example program that demonstrates memory
management issues in both C++ and Fortran. The main goal is to illustrate
debugging techniques for memory-related bugs, such as buffer overflows or
invalid memory access, using `gdb` and its `commands` feature.

The ultimate aim is to use the debugger to set breakpoints and inspect the
program state at the moment a memory error occurs, helping you understand and
resolve such bugs.

## Building

To build the C++/Fortran versions of the memory example, run:

```bash
make
```

This will compile the source files `sums.cpp`/`sums.f90` and produce the
executables `sums-*.exe`.

Both codes perform operations on arrays and are designed to trigger memory
errors under certain conditions. For example, they may access memory outside the
bounds of an array, causing a segmentation fault or a Fortran runtime error.

In C++, a typical error might look like:

```cpp
    int arr[10];
    arr[10] = 42; // Out-of-bounds access (valid indices are 0-9)
```

In Fortran, a similar error could be:

```fortran
    integer, dimension(10) :: arr
    arr(11) = 42 ! Out-of-bounds access (valid indices are 1-10)
```

## Debugging

`gdb` debug scripts (`sums-*.gdb`) are provided to help debug the C++ and
Fortran versions of the code. To debug the Fortran program using `gdb` and the
provided script, you can run:

```bash
gdb -x sums-f90.gdb sums-f90.exe
```

The `-x [filename]` option tells `gdb` to execute commands from the file
`[filename]` while debugging the program `sums-f90.exe`.

The debug script `sums-f90.gdb` (and the similar `sums-cpp.gdb` for C++)
typically contains:

```gdb
start
b compute_sums
c
watch array_squares[0]
c
c
finish
# modify the variable to see if code completes
set var array_squares[0]=1
c
```

- `start`: Begin program execution and stop at the main function.
- `b compute_sums`: Set a breakpoint at the function `compute_sums`.
- `c`: [c]ontinue program execution (`c` is short for continue)
- `watch array_squares[0]`: Set a watchpoint to break when `array_squares[0]` changes.
- `c`: Continue execution (after hitting the watchpoint or breakpoint).
- `c`: Continue execution again.
- `finish`: Run until the current function (`compute_sums`) returns.
- `set var array_squares[0]=1`: Modify the value of `array_squares[0]` to 1.
- `c`: Continue execution.

