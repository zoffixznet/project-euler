import sys
from bigfloat import precision, BigFloat, const_pi, sqrt, asin

if sys.version_info > (3,):
    long = int
    xrange = range

with precision(100):
    L_sect_area = (1 - BigFloat(const_pi())/4)

    def calc_ratio(n):
        l = BigFloat(0)
        h = BigFloat(1)
        m = (l + h)*0.5

        def calc_y1(x):
            return x/n

        def diff(x):
            return (calc_y1(x) - (1 - sqrt(1-(1-x)**2)))
        m_d = diff(m)
        DIFF = BigFloat('1e-20')
        while abs(m_d) > DIFF:
            if m_d < 0:
                l = m
            else:
                h = m
            m = (l + h)*0.5
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
        l = 1
        h = 2
        have = calc_ratio(h)
        while have >= want:
            l = h
            h <<= 1
            have = print_ratio(h)
        m = (l+h) >> 1
        have = print_ratio(m)
        prev_have = calc_ratio(m-1)
        while have >= want or prev_have < want:
            if prev_have < want:
                h = m
            else:
                l = m
            m = (l+h) >> 1
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
