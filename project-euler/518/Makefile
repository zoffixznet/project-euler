all: euler_518_v1.exe euler_518_v1-debug.exe euler_518_v2.exe euler_518_v2-debug.exe

CPPFLAGS = -std=gnu++11

SOURCES = euler_518_v1.cpp primes.txt

euler_518_v1-debug.exe: $(SOURCES)
	g++ $(CPPFLAGS) -g -Wall -o $@ $< -lm

euler_518_v1.exe: $(SOURCES)
	g++ $(CPPFLAGS) -O3 -Wall -flto -fwhole-program -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $< -lm

euler_518_v2-debug.exe: euler_518_v2.cpp
	g++ $(CPPFLAGS) -g -Wall -o $@ $< -lm

euler_518_v2.exe: euler_518_v2.cpp
	g++ $(CPPFLAGS) -O3 -Wall -flto -fwhole-program -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $< -lm

primes.txt:
	primes 2 100000000 > $@

factored.txt: primes.txt
	< $< perl -lpE '++$_' | factor > $@

by-pivot-factor/3.txt: factored.txt
	pypy-c gen-pivots.py

clean:
	rm -f *.exe
