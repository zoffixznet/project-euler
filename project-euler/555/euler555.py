class M_func:
    """docstring for M_func"""
    def __init__(self, m, k, s):
        self.m = m
        self.k = k
        self.s = s
        return

    def calc(self, n):
        """docstring for calc"""
        if n > self.m:
            return n - self.s
        else:
            return self.calc(self.calc(n + self.k))

    def calc_F(self):
        return [x for x in range(0,self.m+1) if self.calc(x) == x]

    def calc_SF(self):
        """docstring for calc_SF"""
        return sum(self.calc_F())


class S_func:
    def __init__(self, p, m):
        self.p = p
        self.m = m

    def calc(self):
        """docstring for calc"""
        ret = 0
        for k in range(2, self.p+1):
            for s in range(1, k):
                ret += M_func(self.m, k, s).calc_SF()
        return ret
