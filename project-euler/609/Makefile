all: primes.txt

primes.txt:
	primes 2 100000000 > $@

clean:
	rm -f 423.exe

test: all
	PYTHONPATH=`pwd`/../555/:`pwd` prove t/*.py
