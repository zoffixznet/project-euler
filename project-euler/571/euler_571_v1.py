import unittest

def _get_digits(b, n):
    ret = []
    while n > 0:
        ret.append(n % b)
        n /= b
    return ret

def _from_digits(b, d):
    ret = long(0)
    e = 1
    for x in d:
        ret += x * e
        e *= b
    return ret

class BaseNum(object):
    """Based Num object"""
    def __init__(self, b, n, digits=None):
        if not digits:
            digits = _get_digits(b, n)
        self.b, self.n, self.digits = b, n, digits
    def _gen_min(self, pad):
        min_ = [1, 0] + ([0] * pad) + range(2,self.b)
        min_ = min_[::-1]
        return BaseNum(self.b, _from_digits(self.b, min_), min_)
    def next_pan(self):
        min_ = self._gen_min(0)
        if self.n <= min_.n:
            return min_
        all_b_m_1 = True
        for d in self.digits:
            if d != self.b - 1:
                all_b_m_1 = False
                break
        if all_b_m_1:
            return self._gen_min(len(self.digits) - self.b + 1)
        count_found = 0
        counts = [{'d':[0 for x in xrange(0, self.b)],'count_found':count_found}]
        for d in self.digits[::-1]:
            new_c = [x for x in counts[-1]['d']]
            if new_c[d] == 0:
                count_found += 1
            new_c[d] += 1
            counts.append({'d':new_c, 'count_found': count_found})
        if counts[-1]['count_found'] == self.b:
            return self
        num_so_far = 1
        for c in counts[::-1]:
            if num_so_far >= self.b - c['count_found']:
                zero_digs = [x for x in xrange(0,len(c['d'])) if (c['d'][x] == 0)]
                assert len(zero_digs) == num_so_far
                # Let's rock-and-roll.
                digs = zero_digs[::-1] + self.digits[num_so_far:]
                return BaseNum(self.b, _from_digits(self.b, digs), digs)
            num_so_far += 1
        return None

class IntegerArithmeticTestCase(unittest.TestCase):
    def testBaseNum(self):  # test method names begin with 'test'
        bn1 = BaseNum(10, 567)
        self.assertEqual(bn1.digits, [7,6,5])
        bn2 = BaseNum(2, 0*1+1*2+1*4+0*8+1*16)
        self.assertEqual(bn2.digits, [0,1,1,0,1])
    def testNextPan(self):
        bn1 = BaseNum(2,0)
        pan1 = bn1.next_pan()
        self.assertEqual(pan1.digits, [0,1])
        pan = BaseNum(3,0).next_pan()
        self.assertEqual(pan.digits, [2,0,1])
        pan = BaseNum(6,0).next_pan()
        self.assertEqual(pan.digits, [5,4,3,2,0,1])
        # Testing beyond 0.
        pan = BaseNum(6,20).next_pan()
        self.assertEqual(pan.digits, [5,4,3,2,0,1])
        # Testing beyond min.
        pan = BaseNum(2,1*1+1*2).next_pan()
        self.assertEqual(pan.digits, [0,0,1])
        pan = BaseNum(3, _from_digits(3, [2,2,2,2,2,2])).next_pan()
        self.assertEqual(pan.digits, [2,0,0,0,0,0,1])
        pan = BaseNum(2, _from_digits(2, [1,0,1])).next_pan()
        self.assertEqual(pan.digits, [1,0,1])
        pan = BaseNum(10, 2222222222).next_pan()
        self.assertEqual(pan.n, 2013456789)
        return

if __name__ == '__main__':
    unittest.main()
