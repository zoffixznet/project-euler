#!/usr/bin/env python3
import math
import sys
if sys.version_info > (3,):
    long = int


class ArithSeq:
    def __init__(self):
        self.i = 1

    # Peek
    def p(self):
        return self.i

    # The next element.
    def n(self):
        ret = self.i
        self.i += 1
        return ret

    # Advance
    def _adv(self, c):
        self.i += c
        return

    def sum(self, c):
        bottom = self.i
        self._adv(c)
        top = self.i - 1
        return (((long(top) + long(bottom)) * long(c)) >> 1)


class FracSeq:
    def __init__(self):
        self._a = ArithSeq()
        self._q = [['a', 1, self._a.p()], ['f', 1, 1]]
        self._a._adv(1)
        self._f = False

    def _append(self):
        if (not self._f):
            self._f = FracSeq()
            self._f.n()
        new_peek = self._f.n()
        c = long(math.sqrt(new_peek))
        self._q.append(['a', c, self._a.p()])
        self._a._adv(c)
        self._q.append(['f', 1, new_peek])
        return

    # Advance
    def _adv(self):
        if (self._q[0][0] == 'f'):
            self._append()
        self._q.pop(0)
        return

    # Next range
    def n_r(self):
        first = self._q[0]
        (count, peek) = first[1], first[2]
        self._adv()
        return (peek, peek+count-1)

    def n(self):
        first = self._q[0]
        (which, count, peek) = first[0], first[1], first[2]
        if (count == 0):
            self._adv()
            return self.n()
        first[1] -= 1
        if (which == 'a'):
            first[2] += 1
        return peek

    def _sum_old(self, cnt):
        ret = long(0)
        # Trace
        t = 1000000000
        fc = 0
        while (cnt > 0):
            while (fc > t):
                print("Reached %d" % (t))
                t += 1000000000
            first = self._q[0]
            (which, count, peek) = first[0], first[1], first[2]
            c = 0
            if (which == 'a'):
                c = (count if (count < cnt) else cnt)
                bottom = peek
                top = bottom + c - 1
                ret += (((long(top) + long(bottom)) * long(c)) >> 1)
            else:
                c = 1
                ret += peek
                self._append()
            cnt -= c
            fc += c
            if c == count:
                self._q.pop(0)
            else:
                first[1] -= c
        return ret

    def sum_by_range(self, cnt):
        ret = long(0)
        # Trace
        S = long('10000000000000')
        t = S
        fc = 0
        f = FracSeq()
        a = ArithSeq()
        while (cnt > 0):
            while (fc > t):
                print("Reached %d" % (t))
                t += S
            (r_s, r_e) = f.n_r()
            if r_s == r_e:
                root = long(math.sqrt(r_s))
                if root >= cnt:
                    ret += a.sum(cnt)
                    fc += cnt
                    cnt = 0
                else:
                    c_delta = root + 1
                    ret += a.sum(root) + r_s
                    cnt -= c_delta
                    fc += c_delta
            else:

                # print ("r_s,r_e=%d,%d" % (r_s, r_e))

                # Bottom root.
                bottom = r_s
                bottom_root = long(math.sqrt(r_s))
                next_root = bottom_root + 1
                next_sq = next_root * next_root - 1

                end_t = r_e
                end_b = bottom
                end = end_t
                while cnt > 0 and bottom <= end:
                    top = (next_sq if next_sq < end else end)

                    # print ("top=%d" % (top))

                    c_delta1 = (top-bottom+1)
                    root_sum = c_delta1 * bottom_root
                    c_delta = root_sum + c_delta1

                    check = False

                    if (c_delta > cnt):
                        end_t = end-1
                        print(("{f}c_delta=%d ; cnt=%d") % (c_delta, cnt))
                        if end_b > end_t:
                            check = True
                            print(("{g}c_delta=%d ; cnt=%d") % (c_delta, cnt))
                            while c_delta > cnt:
                                print(("c_delta=%d") % (c_delta))
                                c_delta1 -= 1
                                root_sum = c_delta1 * bottom_root
                                c_delta = root_sum + c_delta1
                                print(("{d}c_delta=%d ; cnt=%d") %
                                      (c_delta, cnt))
                        else:
                            end = ((end_t + end_b) >> 1)
                            continue
                    elif (c_delta < cnt and end < r_e):
                        print(("{b}c_delta=%d ; cnt=%d") % (c_delta, cnt))
                        if end_b > end_t:
                            check = True
                            print(("{G}c_delta=%d ; cnt=%d") % (c_delta, cnt))
                        else:
                            end_b = end+1
                            end = ((end_t + end_b) >> 1)
                            continue

                    ret += a.sum(root_sum) + \
                        ((c_delta1*((bottom << 1) + c_delta1-1)) >> 1)

                    if check:
                        ret += a.sum(cnt - c_delta)
                        c_delta = cnt

                    cnt -= c_delta
                    fc += c_delta

                    bottom = next_sq + 1
                    bottom_root += 1
                    next_root += 1
                    next_sq = next_root * next_root - 1
        return ret


def frac_sum(n):
    return FracSeq().sum_by_range(n)


def debug_sum(n):
    print("T(%d) = %d\n" % (n, frac_sum(n)))


def debug_sum_w_old(n):
    print("T(%d) = %d ; %d\n" % (n, frac_sum(n), FracSeq()._sum_old(n)))

# debug_sum_w_old(long(sys.argv[1]))
# exit(0)
debug_sum(20)
debug_sum(1000)
debug_sum(1000000000)

debug_sum(long('1000000000000000000'))
