all: 423.exe 423-debug.exe primes.txt

423.exe: euler_423_v1.c
	gcc -std=gnu99 -O3 -Wall -flto -fwhole-program -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $< -lm

423-debug.exe: euler_423_v1.c
	gcc -std=gnu99 -g -o $@ $< -lm

primes.txt:
	primes 2 50000000 > $@

clean:
	rm -f 423.exe

test: all
	PYTHONPATH=`pwd`/../555/:`pwd` prove t/*.py
