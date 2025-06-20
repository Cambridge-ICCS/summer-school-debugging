FC:=gfortran
CXX:=g++
FLAGS=-g -O0 -Wall -fno-omit-frame-pointer
.PHONY: all

all: play-f90.exe play-cpp.exe

play-cpp.exe: play.cpp
	$(CXX) $(FLAGS) $^ -o $@

play-f90.exe: play.f90
	$(FC) $(FLAGS) $(FFLAGS) $^ -o $@

clean:
	rm -f *.exe
