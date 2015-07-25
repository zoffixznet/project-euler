FFILE = factors-2-to-1000000.txt

all: $(FFILE) e320-debug.exe

e320-debug.exe: euler_320_v1.cpp
	g++ -std=gnu++11 -g -Wall -o $@ $< -lm -lgmp -lgmpxx

$(FFILE):
	seq 2 1000000 | xargs factor | perl -lane 's/.*?: //; my %x; $$x{$$_}++ for split/\s+/;print join(",", %x)' > $@

test:
	prove t/*.t
