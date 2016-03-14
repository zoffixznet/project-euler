all: euler_551_v1.exe euler_551_v1-debug.exe

CPPFLAGS = -std=gnu++11

SOURCES = euler_551_v1.cpp

euler_551_v1-debug.exe: $(SOURCES)
	g++ $(CPPFLAGS) -g -Wall -o $@ $< -lm

euler_551_v1.exe: $(SOURCES)
	g++ $(CPPFLAGS) -O3 -Wall -flto -fwhole-program -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $< -lm

clean:
	rm -f *.exe
