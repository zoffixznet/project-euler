all: e521-debug.exe e521-prod.exe

e521-debug.exe: euler_521_v2.cpp
	g++ -std=gnu++11 -g -Wall -o $@ $< -lm

e521-prod.exe: euler_521_v2.cpp
	g++ -std=gnu++11 -O3 -Wall -flto -fwhole-program -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $< -lm

test:
	prove t/*.t
