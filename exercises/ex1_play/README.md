# Play Example

This directory contains a program that can be used as a playground to explore simple `gdb` commands.

The ultimate goal is to use the debugger to set a breakpoint only when the program fails, allowing
you to inspect the state of the program at the moment of the crash and understand the cause of the
intermittent failure.

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

To run our target program `play-f90.exe`/`play-cpp.exe` under `gdb` run the command

```
gdb ./play-f90.exe
```

### How to view the Textual User Interface
### Basic stepping commands
### How to set breakpoints
### Skip commands
### How to set breakpoints
### How to print variables
