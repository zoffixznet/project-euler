all: euler_611_v1.exe euler_611_v1-debug.exe

SOURCES = euler_611_v1.cpp

euler_611_v1-debug.exe: $(SOURCES)
	g++ -std=gnu++14 -g -Wall -o $@ $< -lm

euler_611_v1.exe: $(SOURCES)
	g++ -std=gnu++14 -O3 -Wall -flto -fwhole-program -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $< -lm

clean:
	rm -f *.exe
