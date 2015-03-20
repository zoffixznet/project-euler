all: euler_301.exe

euler_301.exe: euler_301.c
	gcc -std=gnu99 -Wall -O3 -march=native -flto -fwhole-program -fomit-frame-pointer -o $@ $< -lm
