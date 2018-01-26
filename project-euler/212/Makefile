# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php
all: euler_212_v1.exe euler_212_v1-debug.exe

SOURCES = euler_212_v1.cpp rects_cache.txt

euler_212_v1-debug.exe: $(SOURCES)
	g++ -g -Wall -o $@ $< -lm

euler_212_v1.exe: $(SOURCES)
	g++ -O3 -Wall -flto -fwhole-program -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $< -lm

rects_cache.txt: euler-212-v1.pl CalcRects.pm
	COUNT=1 perl $<

clean:
	rm -f *.exe bit_counts.h
