# The Expat License
#
# Copyright (c) 2017, Shlomi Fish
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import sys
from bigfloat import precision, BigFloat

if sys.version_info > (3,):
    long = int
    xrange = range


def transform(s, l):
    with precision(100):
        ret = [BigFloat(0) for x in xrange(1 + s * (len(l)-1))]
        prev = [1]
        for i, v in enumerate(l):
            if i > 0:
                f = BigFloat(1) / (BigFloat(s) ** i)
                new = [BigFloat(0) for x in xrange(1 + s * i)]
                for faceval in xrange(1, s+1):
                    for idx, val in enumerate(prev):
                        new[idx+faceval] += val
                if v > 0:
                    for idx, val in enumerate(new):
                        ret[idx] += val * v * f
                prev = new
        # while ret[-1] == 0:
        #     ret.pop()
        print("s = ", s, " ; ret = ", ["%f" % x for x in ret])
        sys.stdout.flush()
        return [x/sum(ret) for x in ret]


def calc_variance(x12):
    from bigfloat import precision, BigFloat
    num_faces = 20
    with precision(100):
        n = 0
        s = 0
        s_sq = BigFloat(0)
        this_base_n = BigFloat(1)
        base_s_sq = sum([x*x for x in xrange(1, 20+1)])
        base_s = sum([x for x in xrange(1, 20+1)])
        base_var = BigFloat(base_s_sq)/20 - BigFloat(base_s * base_s)/20/20
        for i, v in enumerate(x12):
            f = BigFloat(1) / (BigFloat(num_faces) ** i)
            n += f * this_base_n * v
            s += f * ((this_base_n * v * i * (1+20))*0.5)
            var = base_var * i
            var_less = var + BigFloat(base_s * base_s * i * i)/20/20
            sq = var_less * this_base_n
            s_sq += f * sq * v
            this_base_n *= 20
        return ((BigFloat(s_sq) / BigFloat(n)) -
                ((BigFloat(s)/BigFloat(n)) ** 2))


def calc_variance_brute(x12):
    s = 20
    with precision(100):
        s_sq = [0, 0, 0]
        for i, v in enumerate(x12):
            if i > 0:
                f = BigFloat(1) / (BigFloat(s) ** i)
                print("i = ", i)

                def rec(s_sq, sum_, c):
                    if (c == i):
                        s_sq[0] += f * v * sum_ * sum_
                        s_sq[1] += f * v * sum_
                        s_sq[2] += f * v
                    else:
                        for x in xrange(1, 21):
                            rec(s_sq, sum_+x, c+1)
                rec(s_sq, 0, 0)
        print("s_sq = ", s_sq)
        return (BigFloat(s_sq[0])/BigFloat(s_sq[2]) -
                ((BigFloat(s_sq[1])/BigFloat(s_sq[2]))**2))


def both(x12):
    print("\n\n=========\n\n")
    print("x12 = ", x12)
    print("Good: %f" % calc_variance_brute(x12))
    print("Fast: %f" % calc_variance(x12))
    sys.stdout.flush()
    return


def transform_brute(s, l):
    with precision(100):
        ret = [BigFloat(0) for x in xrange(1 + s * (len(l)-1))]
        for i, v in enumerate(l):
            if i == 0:
                continue

            def rec(sum_, c):
                if i == c:
                    ret[sum_] += BigFloat(v)/(BigFloat(s)**i)
                else:
                    for x in xrange(1, s+1):
                        rec(sum_+x, c+1)
            rec(0, 0)
        return [x/sum(ret) for x in ret]


def transform_both(s, l):
    good = transform_brute(s, l)
    fast = transform(s, l)

    def norm(my_list):
        return ["%.6e" % x for x in my_list]
    if norm(good) != norm(fast):
        raise BaseException("Foo")
    print("Sum = ", sum(fast))
    sys.stdout.flush()
    return fast


def main():
    x4 = transform_both(4, [0, 1])
    x6 = transform_both(6, x4)
    if True:
        transform_both(12, [0, 1, 2])
        transform_both(12, [0, 1, 4, 1])
        transform_both(12, [0, 1, 4, 8])
    x8 = transform(8, x6)
    x12 = transform(12, x8)
    # x20 = transform(20, x12)
    both([0, 1])
    both([0, 2])
    both([0, 0, 1])
    both([0, 0, 0, 1])
    both([0, 1, 1])
    both([0, 2, 1])
    both([0, 2, 2])
    both([0, 2, 2, 5])
    # both([0, 2, 2, 5, 10, 9])
    print("x12: %.4f" % calc_variance(x12))


if __name__ == "__main__":
    main()
