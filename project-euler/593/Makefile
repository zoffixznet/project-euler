all: primes.txt S1.txt

primes.txt:
	primes 2 2000000000 | head -10000000 > $@

S1.txt: S1.py primes.txt
	pypy-c $<
