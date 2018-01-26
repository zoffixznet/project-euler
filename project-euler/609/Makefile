# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php
all: primes.txt

primes.txt:
	primesieve -p1 2 100000000 > $@

clean:
	rm -f 423.exe

test: all
	PYTHONPATH=`pwd`/../555/:`pwd` prove t/*.py
