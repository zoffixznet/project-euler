all: euler_193_v1.exe euler_193_v1-debug.exe

SOURCES = euler_193_v1.cpp bit_counts.h

bit_counts.h: gen.pl
	perl $< $@

euler_193_v1-debug.exe: $(SOURCES)
	g++ -g -Wall -o $@ $< -lm

euler_193_v1.exe: $(SOURCES)
	g++ -O3 -Wall -flto -fwhole-program -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $< -lm

clean:
	rm -f *.exe bit_counts.h
