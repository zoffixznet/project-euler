all: 154.exe 154.clang.exe 154-debug.clang.exe

154.exe: euler_154_v1.c
	gcc -std=gnu99 -O3 -Wall -fwhole-program -flto -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $<

154.clang.exe: euler_154_v1.c
	clang -std=gnu99 -O3 -o $@ $<

154-debug.clang.exe: euler_154_v1.c
	clang -g -std=gnu99 -o $@ $<
