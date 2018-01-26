# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php
all: euler_261_v1.exe euler_261_v1-debug.exe

SOURCES = euler_261_v1.cpp

euler_261_v1-debug.exe: $(SOURCES)
	g++ -std=gnu++14 -g -Wall -o $@ $< -lm

euler_261_v1.exe: $(SOURCES)
	g++ -std=gnu++14 -O3 -Wall -flto -fwhole-program -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $< -lm

clean:
	rm -f *.exe
