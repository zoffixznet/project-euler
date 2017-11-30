all: e427-2-debug.exe e427-2-prod.exe

e427-2-debug.exe: euler_427_v2.cpp
	g++ -std=gnu++11 -g -Wall -o $@ $< -lm -lgmp -lgmpxx

e427-2-prod.exe: euler_427_v2.cpp
	g++ -std=gnu++11 -O3 -Wall -flto -fwhole-program -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $< -lm -lgmp -lgmpxx
