all: e407-debug.exe e407-prod.exe

e407-debug.exe: euler_407_v1.cpp
	g++ -std=gnu++11 -g -Wall -o $@ $< -lm -lgmp -lgmpxx

e407-prod.exe: euler_407_v1.cpp
	g++ -std=gnu++11 -O3 -Wall -flto -fwhole-program -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $< -lm -lgmp -lgmpxx

test:
	prove t/*.t

MAX = 10000000

data: seq.txt prods.txt prods_facts.txt

sol: sol.txt

seq.txt:
	seq "$(MAX)" -1 1 > $@

prods.txt: seq.txt
	cat $< | perl -lanE 'print ($$_ * ($$_-1))' > $@

prods_facts.txt: prods.txt
	factor < $< > $@

sol.txt: prods_facts.txt prods.txt seq.txt
	paste seq.txt prods_facts.txt | tail -251000 | perl euler-407-v2.pl | tee sol.txt
