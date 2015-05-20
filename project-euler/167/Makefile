all: euler_167_v1-debug.exe euler_167_v1.exe

SOURCES = euler_167_v1.cpp

CPPFLAGS = -std=gnu++0x -fpermissive -Wall

euler_167_v1-debug.exe: $(SOURCES)
	g++ $(CPPFLAGS) -g -o $@ $< -lm

euler_167_v1.exe: $(SOURCES)
	g++ -O3 $(CPPFLAGS) -flto -fwhole-program -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $< -lm

clean:
	rm -f *.exe
