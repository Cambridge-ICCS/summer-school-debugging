# Memory Example

This directory contains a toy example program that demonstrates memory
management issues in both C++ and Fortran. The main goal is to illustrate
debugging techniques for memory-related bugs, such as buffer overflows or
invalid memory access, using `gdb`.

We will learn how to use the `watch` command to track invalid memory read/writes
which will help us identify the source of our buffer overflow.

Buffer overflows can be very difficult to detect as they don't typically
generate compiler errors and they often don't trigger runtime errors either!
Even worse, programs with buffer overflows can appear to run correctly, but they
subtly modify the programs state with unintended consequences.

Memory bugs often depend on the environment they are run in, e.g., the compiler
used, the system architecture, compiler flags used and so on. So for this
example, in order to get a "*consistent*" memory bug that always occurs I had to
use a rather contrived example. This is because I wanted to guarantee that the
memory I corrupt is in a specific part of my program. However, it's important to
note that memory errors can occur in C++/Fortran codes even if the memory isn't
allocated in this specific way.

## Building

To build the C++/Fortran versions of the memory example, run:

```bash
make
```

This will compile the source files `sums.cpp`/`sums.f90` and produce the
executables `sums-cpp.exe`/`sums-f90.exe` respectively.

Both codes perform summation operations on two arrays, one to compute the sum of
integers from 1 to 50, and the other to compute the sum of its squares. If we
try running the executable we get the following:

```bash
$ ./sums-cpp.exe
sum of integers from 1 to 50 is :: 1275
Error :: sum of the squares of integers from 1 to 50 is wrong.
```

In the next section we will look into how we can use `gdb` to track down this
issue.

## Explore

Luckily our code has detected there is some kind of issue. For some reason the
sum of squares is incorrect. So how would we start debugging this scenario.

One approach is to set a breakpoint at the site of the problem, and then work
our way backwards.

I will show the commands for the C++ version but this applies just as equally to
the fortran example.

First we will run our program in the `gdb` debugger

```bash
gdb -q ./sums-cpp.exe
```

The `-q` flag is not essential, it runs `gdb` in quiet mode, suppressing the
introductory and copyright messages.

Once in `gdb` we can issue the `start` command to begin program execution and
stop at the main function. This will allow us to set breakpoints before any user
code executes.

Recall that our code failed with error saying the sum of squares is wrong. That
print statement occurs on line 62, in functon `validate_square_sum`. Let's set a
breakpoint (`break`) here and start our investigation.

```
$ (gdb) break validate_square_sum
Breakpoint 1 at 0x1376: file sums.cpp, line 57.
```

Now we can `run` the binary and we will stop when we reach the breakpoint.

```
$ (gdb) run
Starting program:
/workspaces/summer-school-debugging/exercises/ex3_memory/sums-cpp.exe 
warning: Error disabling address space randomization: Operation not permitted
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
sum of integers from 1 to 50 is :: 1275

Breakpoint 1, validate_square_sum (sum=42975) at sums.cpp:57
57        if (sum == (N * (N + 1) * (2 * N + 1)) / 6) {
```


## Solution

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

