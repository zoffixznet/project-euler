all: euler_581_v2.exe euler_581_v2-debug.exe

SOURCES = euler_581_v2.cpp

euler_581_v2-debug.exe: $(SOURCES)
	g++ -std=gnu++14 -g -Wall -o $@ $< -lm

euler_581_v2.exe: $(SOURCES)
	g++ -std=gnu++14 -O3 -Wall -flto -fwhole-program -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $< -lm

clean:
	rm -f *.exe
