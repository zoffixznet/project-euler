all: euler_611_v1.exe euler_611_v1-debug.exe euler_611_v2.exe euler_611_v2-debug.exe euler_611_v3.exe euler_611_v3-debug.exe

SOURCES = euler_611_v1.cpp
SOURCES2 = euler_611_v2.cpp
SOURCES3 = euler_611_v3.cpp

euler_611_v1-debug.exe: $(SOURCES)
	g++ -std=gnu++14 -g -Wall -o $@ $< -lm

euler_611_v1.exe: $(SOURCES)
	g++ -std=gnu++14 -O3 -Wall -flto -fwhole-program -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $< -lm


euler_611_v2-debug.exe: $(SOURCES2)
	g++ -std=gnu++14 -g -Wall -o $@ $< -lm

euler_611_v2.exe: $(SOURCES2)
	g++ -std=gnu++14 -O3 -Wall -flto -fwhole-program -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $< -lm

euler_611_v3-debug.exe: $(SOURCES3)
	g++ -std=gnu++14 -g -Wall -o $@ $< -lm

euler_611_v3.exe: $(SOURCES3)
	g++ -std=gnu++14 -O3 -Wall -flto -fwhole-program -fvisibility=hidden -fomit-frame-pointer -march=native -o $@ $< -lm

clean:
	rm -f *.exe
