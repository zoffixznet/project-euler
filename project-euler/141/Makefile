all: 141.exe 141-2.exe 141-2-debug.exe factors.txt

141.exe: euler-141-1.c
	gcc -std=gnu99 -O3 -Wall -flto -fwhole-program -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $< -lm

141-2.exe: euler-141-2.cpp
	g++ -std=gnu++11 -O3 -Wall -flto -fwhole-program -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $< -lm

141-2-debug.exe: euler-141-2.cpp
	g++ -std=gnu++11 -g -o $@ $< -lm

factors.txt:
	seq 2 999999 | xargs factor | perl -lpe 's/^[^:]+:\s*//; s/\s*\z/ -1/;' > $@
