all: P_1M.txt

P_1M.txt:
	primes 2 100000000 | head -1000000 | rev | tac | perl -nE 'chomp;print' > $@
