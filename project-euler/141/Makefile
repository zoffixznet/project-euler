all: 141.exe

141.exe: euler-141-1.c
	gcc -std=gnu99 -O3 -Wall -flto -fwhole-program -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $< -lm
