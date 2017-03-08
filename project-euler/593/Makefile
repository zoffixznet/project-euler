all: primes.txt S1.txt S2.txt F.exe

primes.txt:
	primes 2 2000000000 | head -10000000 > $@

S1.txt: S1.py primes.txt
	pypy-c $<

S2.txt: S2.py S1.txt
	pypy-c $<

F.exe: F.cpp
	g++ -std=gnu++11 -O3 -Wall -flto -fwhole-program -fvisibility=hidden -fomit-frame-pointer -march=native -I. -o $@ $< -lm
