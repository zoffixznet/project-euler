# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php
all: 423.exe 423-debug.exe primes.txt

423.exe: euler_423_v1.cpp
	gcc -std=gnu++11 -O3 -Wall -flto -fwhole-program -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $< -lm -lstdc++

423-debug.exe: euler_423_v1.cpp
	g++ -std=gnu++11 -g -o $@ $< -lm -lstdc++

423-clang.exe: euler_423_v1.cpp
	clang++ -std=gnu++11 -O3 -Wall -fuse-ld=gold -flto -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $<
	# clang++ -std=gnu++11 -O3 -Wall -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $< -lm -lstdc++

primes.txt:
	primes 2 50000000 > $@

clean:
	rm -f 423.exe

test: all
	PYTHONPATH=`pwd`/../555/:`pwd` prove t/*.py
