import math
import sys

if sys.version_info > (3,):
    long = int
    xrange = range

def mydiv(i,e):
    ret = (i/e)*e;
    if ret < i:
        return ret + e
    else:
        return ret

class Powers:
    """docstring for Powers"""
    def __init__(self, p, max_, i):
        self.p = p
        self.i = i
        self.max_ = max_

        e = p
        self.a = [[e,mydiv(i,e)]]
        while e < max_:
            e *= p
            self.a.append([e, mydiv(i,e)])
        return

    def calc(self):
        i = self.i
        r = 0
        for x in self.a:
            if x[1] == i:
                r += 1
                x[1] += x[0]
            else:
                break
        self.i += 1
        return r

def C(i,n):
    return (math.factorial(i) / (math.factorial(n) * math.factorial(i-n)))

def T(m, n):
    numer = [Powers(long(2), m, n+1), Powers(long(5), m, n+1)]
    denom = [Powers(long(2), m, 1), Powers(long(5), m, 1)]
    s = [0,0]
    ret = 0
    verd = False
    for i in range(n, m):
        if verd:
            ret += 1
        verd = True
        for j in [0,1]:
            s[j] += numer[j].calc() - denom[j].calc()
            if s[j] < 1:
                verd = False
        if False:
            real_verd = (C(i+1,n) % 10 == 0)
            if real_verd != verd:
                raise BaseException( "real_verd=%s verd=%s i=%d" % (real_verd, verd, i))
        if i % 1000000 == 0:
            print("i = %d ; ret = %d" % (i, ret))
            sys.stdout.flush()
    return ret

def main():
    print("ret = %d" % (T(100,5)))
    m = long('1' + '0' * 9)
    n = long(10000000 - 10)
    print("ret = %d" % (T(m,n)))

if __name__ == "__main__":
    main()
