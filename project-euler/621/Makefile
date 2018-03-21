all: dummy

R = $(shell seq 0 9999)

P = $(patsubst %,parts/%.t,$(R))

dummy: $(P)

$(P): %:
	/home/shlomif/Download/unpack/prog/python/pypy3-v5.5.0-src/pypy-c euler_621_v1.py $(patsubst parts/%.t,%,$@) | tee -a $@

summary:
	cat parts/*.t | grep -E '^:' | sort -u | perl -lanE '@x=/([0-9]+)/g; $$s += ($$x[-1] == $$x[0] ? 1 : $$x[0] == $$x[1] ? 3 : $$x[1] == $$x[2] ? 3 : 6); END { print "s = $$s\n";}'
