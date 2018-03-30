all: exes

R = $(shell seq 0 9999)
# R = $(shell seq 0 9)

P = $(patsubst %,parts/%.t,$(R))

exes: e.exe

e.exe: euler_621_v1.cpp
	g++ -Wall -Wextra -O3 -march=native -flto -fwhole-program -o $@ $< -lm

dummy: $(P)

$(P): %:
	./e.exe $(patsubst parts/%.t,%,$@) >> $@

summary:
	cat parts/*.t | grep -E '^:' | sort -u | perl -lanE '@x=/([0-9]+)/g; $$s += ($$x[-1] == $$x[0] ? 1 : $$x[0] == $$x[1] ? 3 : $$x[1] == $$x[2] ? 3 : 6); END { print "s = $$s\n";}'
