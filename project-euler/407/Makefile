all: e407-debug.exe e407-prod.exe

e407-debug.exe: euler_407_v1.cpp
	g++ -std=gnu++11 -g -Wall -o $@ $< -lm -lgmp -lgmpxx

e407-prod.exe: euler_407_v1.cpp
	g++ -std=gnu++11 -O3 -Wall -flto -fwhole-program -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $< -lm -lgmp -lgmpxx

test:
	prove t/*.t
