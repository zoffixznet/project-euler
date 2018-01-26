# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

all: factor.db gen.db result.txt

factor.db:
	(echo ; seq 1 1000000 | factor) > $@

gen.db: gen.pl factor.db
	perl gen.pl > $@

result.txt: gen.db
	cat $< | sort -u | perl -Mbigint -nlE 'BEGIN { $$s = 0; } $$s += $$_; END { say $$s; }' | tee $@
