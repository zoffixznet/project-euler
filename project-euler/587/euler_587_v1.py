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
from bigfloat import precision, BigFloat, const_pi, sqrt, asin

if sys.version_info > (3,):
    long = int

with precision(100):
    L_sect_area = (1 - BigFloat(const_pi())/4)

    def calc_ratio(n):
        low = BigFloat(0)
        h = BigFloat(1)
        m = (low + h)*0.5

        def calc_y1(x):
            return x/n

        def diff(x):
            return (calc_y1(x) - (1 - sqrt(1-(1-x)**2)))
        m_d = diff(m)
        DIFF = BigFloat('1e-20')
        while abs(m_d) > DIFF:
            if m_d < 0:
                low = m
            else:
                h = m
            m = (low + h)*0.5
            m_d = diff(m)
        x = x1 = m
        y1 = calc_y1(x)
        left_area = x1*y1*0.5
        right_area = ((y1+1)*(1-x1)*0.5 - asin(1-x1)*0.5)
        return ((left_area + right_area) / L_sect_area)

    def print_ratio(n):
        ret = calc_ratio(n)
        print("ratio(%d) = %f" % (n, ret))
        return ret

    def find_first_less_than_ratio(want):
        low = 1
        h = 2
        have = calc_ratio(h)
        while have >= want:
            low = h
            h <<= 1
            have = print_ratio(h)
        m = (low+h) >> 1
        have = print_ratio(m)
        prev_have = calc_ratio(m-1)
        while have >= want or prev_have < want:
            if prev_have < want:
                h = m
            else:
                low = m
            m = (low+h) >> 1
            have = print_ratio(m)
            prev_have = calc_ratio(m-1)
        return m

    def assert_ratio(n, want, fuzz):
        have = calc_ratio(n)
        print("ratio(%d): have = %f ; want = %f" % (n, have, want))
        assert(abs(have-want) < fuzz)
        return

    def print_less_than(want):
        print("first n for %f is %d"
              % (want, find_first_less_than_ratio(want)))

    def main():
        assert_ratio(1, 0.5, 1e-8)
        assert_ratio(2, BigFloat(36.46)/100, 1e-2)
        assert_ratio(15, 0.1, 1e-2)
        print_less_than(0.1)
        print_less_than(BigFloat('1e-3'))

    if __name__ == "__main__":
        main()
