import unittest
import sys

if sys.version_info > (3,):
    long = int
    xrange = range


def _get_digits(b, n):
    ret = []
    while n > 0:
        n, d = divmod(n, b)
        ret.append(d)
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

    def _new_from_digits(self, digits):
        return BaseNum(self.b, _from_digits(self.b, digits), digits)

    def _gen_min(self, pad):
        min_ = [1, 0] + ([0] * pad) + range(2, self.b)
        return self._new_from_digits(min_[::-1])

    def next_pan(self):
        def worker():
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
            counts = [{'d': [0 for x in xrange(0, self.b)],
                       'count_found': count_found}]
            for d in self.digits[::-1]:
                new_c = [x for x in counts[-1]['d']]
                if new_c[d] == 0:
                    count_found += 1
                new_c[d] += 1
                counts.append({'d': new_c, 'count_found': count_found})
            if counts[-1]['count_found'] == self.b:
                return self
            num_so_far = 1
            for c in counts[::-1]:
                if num_so_far >= self.b - c['count_found']:
                    # Let's rock-and-roll.
                    zero_digs = [x for x in xrange(0, len(c['d']))
                                 if (c['d'][x] == 0)]
                    assert len(zero_digs) == num_so_far
                    digs = []
                    for i, d in enumerate(self.digits[(num_so_far-1)::-1]):
                        found_digs = [x for x in zero_digs if x >= d]
                        if len(found_digs) == 0:
                            next_ = (([0] * num_so_far) +
                                     [self.digits[num_so_far]+1] +
                                     self.digits[num_so_far+1:])
                            j = num_so_far
                            while next_[j] == self.b:
                                next_[j] = 0
                                j += 1
                                next_[j] += 1
                            return self._new_from_digits(next_).next_pan()
                        found_d = found_digs[0]
                        zero_digs = [x for x in zero_digs if x != found_d]
                        digs.append(found_d)
                        if found_d > d:
                            digs += zero_digs
                            break
                    return self._new_from_digits(
                        digs[::-1] + self.digits[num_so_far:])
                num_so_far += 1
            return None
        ret = worker()
        if not ret:
            return ret
        assert ret.n >= self.n
        return ret


class FindSuperPans(object):
    """docstring for SuperPan"""
    def __init__(self, max_b, start=1):
        self.max_b = max_b
        self.i = long(start)

    def find_next(self):
        i = self.i
        restart = True
        while restart:
            restart = False
            for b in xrange(self.max_b, 1, -1):
                new = BaseNum(b, i).next_pan()
                if new.n > i:
                    i = new.n
                    restart = True
                    break
        self.i = i+1
        return i

    def sum_lowest_nums(self, count, verbose):
        ret = 0
        for idx in xrange(0, count):
            found_num = self.find_next()
            ret += found_num
            if verbose:
                print("Found the %d -th %d for total=%d" %
                      (idx, found_num, ret))
        if verbose:
            print("Total sum = %d" % (ret))
        return ret


class PanNumTestCase(unittest.TestCase):
    def testBaseNum(self):  # test method names begin with 'test'
        bn1 = BaseNum(10, 567)
        self.assertEqual(bn1.digits, [7, 6, 5])
        bn2 = BaseNum(2, 0*1+1*2+1*4+0*8+1*16)
        self.assertEqual(bn2.digits, [0, 1, 1, 0, 1])

    def testNextPan(self):
        bn1 = BaseNum(2, 0)
        pan1 = bn1.next_pan()
        self.assertEqual(pan1.digits, [0, 1])
        pan = BaseNum(3, 0).next_pan()
        self.assertEqual(pan.digits, [2, 0, 1])
        pan = BaseNum(6, 0).next_pan()
        self.assertEqual(pan.digits, [5, 4, 3, 2, 0, 1])
        # Testing beyond 0.
        pan = BaseNum(6, 20).next_pan()
        self.assertEqual(pan.digits, [5, 4, 3, 2, 0, 1])
        # Testing beyond min.
        pan = BaseNum(2, 1*1 + 1*2).next_pan()
        self.assertEqual(pan.digits, [0, 0, 1])
        pan = BaseNum(3, _from_digits(3, [2, 2, 2, 2, 2, 2])).next_pan()
        self.assertEqual(pan.digits, [2, 0, 0, 0, 0, 0, 1])
        pan = BaseNum(2, _from_digits(2, [1, 0, 1])).next_pan()
        self.assertEqual(pan.digits, [1, 0, 1])
        pan = BaseNum(10, 2222222222).next_pan()
        self.assertEqual(pan.n, 2301456789)
        pan = BaseNum(10, 2999999999).next_pan()
        self.assertEqual(pan.n, 3012456789)

        # identity.
        pan = BaseNum(10, 12345678906673432425).next_pan()
        self.assertEqual(pan.n, 12345678906673432425)

        pan = BaseNum(10, 10203040506070808).next_pan()
        self.assertEqual(pan.n, 10203040506070809)

        pan = BaseNum(3, _from_digits(3, [2, 0, 2, 2, 2, 2])).next_pan()
        self.assertEqual(pan.digits, [0, 1, 2, 2, 2, 2])

        pan = BaseNum(3, _from_digits(3, [2, 2, 2, 2, 0, 2])).next_pan()
        self.assertEqual(pan.digits, [0, 0, 0, 0, 1, 2])

        return

    def testFindSuperPans(self):
        """docstring for testFindSuperPans"""

        super_pan = FindSuperPans(5)
        self.assertEqual(super_pan.find_next(), 978)

        super_pan = FindSuperPans(10)
        self.assertEqual(super_pan.find_next(), 1093265784)

        super_pan = FindSuperPans(10)
        self.assertEqual(super_pan.sum_lowest_nums(10, False), 20319792309)

if __name__ == '__main__':
    # unittest.main()
    super_pan = FindSuperPans(12)
    super_pan.sum_lowest_nums(10, True)
