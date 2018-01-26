# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php
all: euler_301.exe

euler_301.exe: euler_301.c
	gcc -std=gnu99 -Wall -O3 -march=native -flto -fwhole-program -fomit-frame-pointer -o $@ $< -lm
