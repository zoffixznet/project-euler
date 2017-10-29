all: e305-debug.exe e305-prod.exe buf.txt

buf.txt:
	perl -E 'my $s = ""; $s .= $_ for 1 .. 1_000_000; say $s' > $@

e305-debug.exe: euler_305_v1.cpp
	g++ -Wall -std=gnu++11 -g -o $@ $<

e305-prod.exe: euler_305_v1.cpp
	g++ -Wall -std=gnu++11 -O3 -fomit-frame-pointer -flto -fwhole-program -fvisibility=hidden -march=native -o $@ $<

test: buf.txt
	WHICH_CMD=1 prove t/*.t
	WHICH_CMD=2 prove t/*.t
	WHICH_CMD=3 prove t/*.t
