# Play Example

This directory contains a program that can be used as a playground to explore simple `gdb` commands.

The ultimate goal of this example is to learn the essential `gdb` commands we will need to debug
programs in the following examples.

## Lesson Objectives

- [x] how to start `gdb`
- [x] how to view the Textual User Interface (TUI) (`--tui` or `CTRL-X-A`)
- [x] basic stepping commands (`next` and `step`)
- [x] how to set breakpoints (`break`)
- [x] skip commands (`run`, `continue` and `until`)
- [x] how to set breakpoints (`break`)
- [x] how to print variables (`print`)

## Building

To build the C++/Fortran versions of the play example, run:

```bash
make
```

This will compile the source files `play.cpp`/`play.f90` and produce the executables `play-*.exe`.

## Debugging

### How to start `gdb`

Type the following command to run the target program (`play-f90.exe`/`play-cpp.exe`) in the debugger
(`gdb`)

```
gdb ./play-f90.exe
```

This should output the following:

```
$ gdb ./play-f90.exe
GNU gdb (Debian 13.1-3) 13.1
Copyright (C) 2023 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<https://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from ./play-f90.exe...
(gdb)
```

This our first step to using the debugger. Before we get started properly, it would be good to know
how to exit the debugger as well. This can be done by typing the `quit` command or by pressing the
keyboard shortcut `CTRL+D`.

Whilst it's handy to see `gdb`'s help text the first time we run `gdb`, we will be running it a lot
this course. So let's launch `gdb` with the `-q` quiet flag which will silence the start up message.

```
$ gdb -q ./play-f90.exe
Reading symbols from ./play-f90.exe...
(gdb)
```

### How to view the Textual User Interface

`gdb` is a Command Line Interface (CLI) debugger but it also ships a Textual User Interface (TUI).
If you have not come across TUIs before they are essentially GUIs (Graphical User Interfaces) but
for the terminal. TUIs are particularly helpful for working on remote systems e.g., HPC, because
they do not require X11 forwarding. This makes them more responsive and sometimes the only option if
X11 forwarding is disabled/blocked.

To run gdb with the TUI we add the following flag `--tui`

```
$ gdb -q --tui ./play-f90.exe
```

This should looks something like the following:

```fortran
┌─play.f90──────────────────────────────────────────────────────┐
│        1  program array_example                               │
│        2      implicit none                                   │
│        3                                                      │
│        4      integer :: i                                    │
│        5      integer, dimension(10) :: data                  │
│        6      integer :: int_var                              │
│        7      real :: real_var                                │
│        8      double precision :: double_var                  │
│        9      logical :: logical_var                          │
│       10                                                      │
│       11      ! Populate the array with values from 1 to 10   │
│       12      do i = 1, 10                                    │
│       13          data(i) = i                                 │
│       14      end do                                          │
│       15                                                      │
│       16      ! Assign values to variables                    │
│       17      int_var = 5                                     │
│       18      real_var = 3.14                                 │
│       19      double_var = 2.718281828459045d0                │
│       20      logical_var = .true.                            │
└───────────────────────────────────────────────────────────────┘
exec No process In:                               L??   PC: ?? 
Reading symbols from ./play-f90.exe...
(gdb)
```

![gdbtui](https://github.com/Cambridge-ICCS/summer-school-debugging/tree/main/exercises/ex1_play/imgs/gdb-tui.png)

### Basic stepping commands
### How to set breakpoints
### Skip commands
### How to set breakpoints
### How to print variables
