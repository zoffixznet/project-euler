all: e521-debug.exe e521-prod.exe e521-v3-prod.exe

e521-debug.exe: euler_521_v2.cpp
	g++ -std=gnu++11 -g -Wall -o $@ $< -lm

e521-prod.exe: euler_521_v2.cpp
	g++ -std=gnu++11 -O3 -Wall -flto -fwhole-program -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $< -lm

e521-v3-debug.exe: euler_521_v3.cpp
	g++ -std=gnu++11 -g -Wall -o $@ $< -lm

e521-v3-prod.exe: euler_521_v3.cpp
	g++ -std=gnu++11 -O3 -Wall -Wextra -flto -fwhole-program -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $< -lm
test:
	prove t/*.t
