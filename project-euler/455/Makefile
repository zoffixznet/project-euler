# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php
all: rainbow_table.txt 455.exe 455-v2.exe 455-v3.exe 455-v4.exe

rainbow_table.txt: euler-455-v4-rainbow-tables-test.pl
	perl $< > $@

455.exe: euler_455_v1.c
	gcc -std=gnu99 -O3 -Wall -fwhole-program -flto -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $<

455_v2.exe: euler_455_v2.c
	gcc -std=gnu99 -O3 -Wall -fwhole-program -flto -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $<

455-v3.exe: euler_455_v3.c
	gcc -std=gnu99 -O3 -Wall -fwhole-program -flto -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $<

455-v4.exe: euler_455_v4.c
	gcc -std=gnu99 -O3 -Wall -fwhole-program -flto -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $<
	# gcc -g -Wall -std=gnu99 -o $@ $<

solution: 455-v4.exe rainbow_table.txt
	./455-v4.exe 2 1000000

N_S = $(shell seq 400 99999)

N_S_RESULTS = $(patsubst %,RESULTS/ten%.result,$(N_S))

results: $(N_S_RESULTS)

$(N_S_RESULTS):
	A="$(patsubst RESULTS/ten%.result,%,$@)"; ./455-v2.exe "$$((A * 10 + 1))" "$$(( (A + 1) * 10 ))" | tee  $@

# A="$(patsubst RESULTS/%.result,%,$@)"; perl euler-455-v2.pl "$$A" "$$A" | tee  $@
#

clean:
	rm -f 455*.exe rainbow_table.txt
