class M_func:
    """docstring for M_func"""
    def __init__(self, m, k, s):
        self.m = m
        self.k = k
        self.s = s
        self._c = None
        return

    def calc(self, n):
        """docstring for calc"""
        if n > self.m:
            return n - self.s
        else:
            if not self._c:
                self._c = [None] * (self.m+1)
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
        min_pos = self.m - wavelen + 1
        val_at_min = min_ + (min_pos - min_)%wavelen
        if val_at_min != min_:
            return long(0)
        max_ = min(m_m, self.m)
        return (((min_+max_)*(max_-min_+1)) >> 1)

def _calc_SF(m, k, s):
    m_m = m + k - (s << 1)
    wavelen = k - s
    min_ = m_m - wavelen + 1
    min_pos = m - wavelen + 1
    val_at_min = min_ + (min_pos - min_)%wavelen
    if val_at_min != min_:
        return long(0)
    max_ = min(m_m, m)
    return ((long(min_+max_)*(max_-min_+1)) >> 1)

class S_func:
    def __init__(self, p, m):
        self.p = p
        self.m = m

    def calc(self):
        """docstring for calc"""
        ret = long(0)
        m = self.m
        for k in xrange(2, self.p+1):
            print (("k=%d") % k)
            for s in xrange(1, k):
                ret += _calc_SF(m, k, s)
        return ret

def main():
    m = 1000
    p = 1000
    print (("S(%d,%d) = %d") % (p,m,S_func(p,m).calc()))

    m = 1000000
    p = 1000000
    print (("S(%d,%d) = %d") % (p,m,S_func(p,m).calc()))

if __name__ == "__main__":
    main()

