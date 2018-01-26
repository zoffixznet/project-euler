# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php
all: euler145 euler145-debug

euler145: euler_145_v1.c
	gcc -Wall -O2 -march=native -fomit-frame-pointer -fwhole-program -flto -o $@ $<

euler145-debug: euler_145_v1.c
	gcc -Wall -g -o $@ $<
