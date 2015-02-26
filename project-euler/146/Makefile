all: db.txt primes-c.txt 146-v1.exe 146-v1-debug.exe 146-v2.exe

db.txt: euler-146-analysis-1.pl
	perl $< | tee $@

146-v1.exe: euler-146-v1.c
	gcc -std=gnu99 -Wall -O3 -march=native -flto -fwhole-program -o $@ $< -lm

146-v1-debug.exe: euler-146-v1.c
	gcc -std=gnu99 -Wall -g -o $@ $< -lm

146-v2.exe: euler-146-v2.c
	gcc -std=gnu99 -Wall -O3 -march=native -flto -fwhole-program -o $@ $< -lm

primes-c.txt:
	primes 2 151000000 > $@
