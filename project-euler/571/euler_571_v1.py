import unittest

def _get_digits(b, n):
    ret = []
    while n > 0:
        ret.append(n % b)
        n /= b
    return ret

class BaseNum(object):
    """Based Num object"""
    def __init__(self, b, n, digits=None):
        if not digits:
            digits = _get_digits(b, n)
        self.b, self.n, self.digits = b, n, digits

class IntegerArithmeticTestCase(unittest.TestCase):
    def testBaseNum(self):  # test method names begin with 'test'
        bn1 = BaseNum(10, 567)
        self.assertEqual(bn1.digits, [7,6,5])

if __name__ == '__main__':
    unittest.main()
