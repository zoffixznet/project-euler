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



def main():
    m = long('1' + '0' * 9)
    n = long(10000000 - 10)

    numer = [Powers(long(2), m, n), Powers(long(5), m, n)]
    denom = [Powers(long(2), m, 1), Powers(long(5), m, 1)]
    s = [0,0]
    ret = 0
    for i in range(n, m):
        verd = True
        for j in [0,1]:
            s[j] += numer[j].calc() - denom[j].calc()
            if s[j] < 1:
                verd = False
        if verd:
            ret += 1
        if i % 1000000 == 0:
            print("i = %d ; ret = %d" % (i, ret))
            sys.stdout.flush()

    print("ret = %d" % (ret))

    return

if __name__ == "__main__":
    main()
