all: euler145 euler145-debug

euler145: euler145.c
	gcc -Wall -O2 -march=native -fomit-frame-pointer -fwhole-program -flto -o $@ $<

euler145-debug: euler145.c
	gcc -Wall -g -o $@ $<
