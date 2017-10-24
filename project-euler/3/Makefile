all: mini_factor-debug.exe mini_factor-prod.exe

GCC_FLAGS = -Wall -Wextra -std=gnu++11

mini_factor-debug.exe: mini_factor.cpp
	g++ $(GCC_FLAGS) -g -o $@ $< -lm

mini_factor-prod.exe: mini_factor.cpp
	g++ $(GCC_FLAGS) -O3 -flto -fwhole-program -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $< -lm

test: all
	prove t/*.t
