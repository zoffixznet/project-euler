all: mod_counts.txt mod_groups.txt

mod_counts.txt: euler-250-v1-step1.pl
	perl $< > $@

mod_groups.txt: mod_counts.txt
	bash euler-250-v1-step2.bash < $< > $@
