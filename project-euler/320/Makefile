FFILE = factors-2-to-1000000.txt

all: $(FFILE)

$(FFILE):
	seq 2 1000000 | xargs factor | perl -lane 's/.*?: //; my %x; $$x{$$_}++ for split/\s+/;print join(",", %x)' > $@

test:
	prove t/*.t
