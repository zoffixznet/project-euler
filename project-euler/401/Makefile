all: euler401_v2.exe

euler401_v2.exe: euler_401_v2.cpp
	g++ -std=gnu++14 -O3 -march=native -flto -fwhole-program -fomit-frame-pointer -o $@ $<

test:
	PYTHONPATH="`pwd`" prove t/*.py
