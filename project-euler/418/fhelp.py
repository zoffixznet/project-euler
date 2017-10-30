import sys

if sys.version_info > (3,):
    long = int
    xrange = range

N = 392387855098337600
x = []
for line in sys.stdin:
    e, f = map(long, line.split())
    p = 1
    s = []
    for i in range(0, e+1):
        s.append(p)
        p *= f
    x.append(s)

x.sort(key=lambda y: y[1])

L = N/2
U = N*2


def f(i, n):
    if n >= U:
        return
    if (i == len(x)):
        if (n > L):
            print(n)
    else:
        for q in x[i]:
            f(i+1, n*q)


f(0, 1)
