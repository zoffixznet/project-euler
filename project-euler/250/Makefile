MOD = 250
MAX = 250250

PREFIX = MOD="$(MOD)" MAX="$(MAX)"

PY = /home/shlomif/Download/unpack/prog/python/pypy2-v5.3.0-src/pypy/goal/pypy-c

GEN_FILES = mod_counts.txt mod_groups.txt

all: $(GEN_FILES)

mod_counts.txt: euler-250-v1-step1.pl
	$(PREFIX) perl $< > $@

mod_groups.txt: mod_counts.txt
	$(PREFIX) bash euler-250-v1-step2.bash < $< > $@

# production.
prod: all
	$(PREFIX) $(PY) euler_250_v1_step3.py

brute: all
	$(PREFIX) $(PY) euler_250_v1_step3_brute_force.py

clean:
	rm -f $(GEN_FILES)

test:
	prove t/*.t
