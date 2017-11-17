all:

primes.txt:
	primesieve -p1 1 100000000 > $@

result: primes.txt
	pypy-c euler_429_v1.py
