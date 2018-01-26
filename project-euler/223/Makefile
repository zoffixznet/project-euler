# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php
all: euler_223_v1.exe euler_223_v1-debug.exe

SOURCES = euler_223_v1.cpp

euler_223_v1-debug.exe: $(SOURCES)
	g++ -g -Wall -o $@ $< -lm

euler_223_v1.exe: $(SOURCES)
	g++ -O3 -Wall -flto -fwhole-program -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $< -lm

clean:
	rm -f *.exe bit_counts.h
