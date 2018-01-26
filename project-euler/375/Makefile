# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php
all: result

DATA = dump_v3

$(DATA): euler_375_v2_step2.py
	pypy-c $< > $@

result: $(DATA)
	perl euler_375_v2_step3.pl
