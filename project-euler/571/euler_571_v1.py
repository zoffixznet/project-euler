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
    def next_pan(self):
        if self.n == 0:
            ret = [1, 0] + range(2,self.b)
            ret = ret[::-1]
            return BaseNum(self.b, _from_digits(self.b, ret), ret)
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
        return

if __name__ == '__main__':
    unittest.main()
