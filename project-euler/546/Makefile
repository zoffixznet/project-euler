all: euler_546_v3.exe euler_546_v3-debug.exe

SOURCES = euler_546_v3.cpp

euler_546_v3-debug.exe: $(SOURCES)
	g++ -std=gnu++11 -g -Wall -o $@ $< -lm

euler_546_v3.exe: $(SOURCES)
	g++ -std=gnu++11 -O3 -Wall -flto -fwhole-program -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $< -lm

clean:
	rm -f *.exe
