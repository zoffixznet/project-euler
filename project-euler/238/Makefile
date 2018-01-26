# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php
all: input.txt euler_238_v1.exe euler_238_v1-debug.exe

SOURCES = euler_238_v1.cpp

euler_238_v1-debug.exe: $(SOURCES)
	g++ -g -Wall -o $@ $< -lm

euler_238_v1.exe: $(SOURCES)
	g++ -O3 -Wall -flto -fwhole-program -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $< -lm

input.txt: euler-238-v1-step1.pl
	perl $<

sums.txt: ./euler_238_v1.exe input.txt
	./euler_238_v1.exe | tee $@

Summary.txt: sums.txt summarize.pl
	perl summarize.pl | tee $@

clean:
	rm -f *.exe bit_counts.h
