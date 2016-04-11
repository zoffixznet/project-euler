class M_func:
    """docstring for M_func"""
    def __init__(self, m, k, s):
        self.m = m
        self.k = k
        self.s = s
        self._c = [None] * (m+1)
        return

    def calc(self, n):
        """docstring for calc"""
        if n > self.m:
            return n - self.s
        else:
            if self._c[n] == None:
                self._c[n] = self.calc(self.calc(n + self.k))
            return self._c[n]

    def calc_F(self):
        # We iterate in reverse because the function is calculated this way.
        return [x for x in xrange(self.m, 0, -1) if self.calc(x) == x]

    def calc_SF(self):
        """docstring for calc_SF"""
        # ret = long(sum(self.calc_F()))
        # print ("s=%d k=%d" % (self.s, self.k))
        # print self._c
        m_m = self.m + self.k - (self.s << 1)
        wavelen = self.k - self.s
        min_ = m_m - wavelen + 1
        if min_ > self.m:
            return long(0)
        min_pos = self.m - wavelen + 1
        val_at_min = min_ + (min_pos - min_)%wavelen
        if val_at_min != min_:
            return long(0)
        max_ = min(m_m, self.m)
        return (((min_+max_)*(max_-min_+1)) >> 1)

class S_func:
    def __init__(self, p, m):
        self.p = p
        self.m = m

    def calc(self):
        """docstring for calc"""
        ret = long(0)
        for k in xrange(2, self.p+1):
            print (("k=%d") % k)
            for s in xrange(1, k):
                ret += M_func(self.m, k, s).calc_SF()
        return ret

def main():
    m = 1000
    p = 1000
    print (("S(%d,%d) = %d") % (p,m,S_func(p,m).calc()))

if __name__ == "__main__":
    main()

