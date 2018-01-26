# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php
all: euler_551_v2.exe euler_551_v2-debug.exe

CPPFLAGS = -std=gnu++11

SOURCES = euler_551_v2.cpp

euler_551_v2-debug.exe: $(SOURCES)
	g++ $(CPPFLAGS) -g -Wall -o $@ $< -lm

euler_551_v2.exe: $(SOURCES)
	g++ $(CPPFLAGS) -O3 -Wall -flto -fwhole-program -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $< -lm

clean:
	rm -f *.exe
