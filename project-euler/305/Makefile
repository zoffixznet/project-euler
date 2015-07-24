all: e305-debug.exe buf.txt

buf.txt:
	perl -E 'my $s = ""; $s .= $_ for 1 .. 1_000_000; say $s' > $@

e305-debug.exe: euler-305-v1.cpp
	g++ -Wall -std=gnu++11 -g -o $@ $<

test: buf.txt
	WHICH_CMD=1 prove t/*.t
	WHICH_CMD=2 prove t/*.t
