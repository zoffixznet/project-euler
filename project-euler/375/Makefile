all: result

DATA = dump_v3

$(DATA): euler_375_v2_step2.py
	pypy-c $< > $@

result: $(DATA)
	perl euler_375_v2_step3.pl
