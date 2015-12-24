def P_list(l, is_left):
    if l == 1:
        return 0
    return ((1 if (is_left or ((l & 0x1) != 0)) else 0) + \
                (
                    (
                        P_list( (l >> 1), (not is_left) )
                    )
                    << 1
                )
    )

def P_list(l, is_left):
    if l == 1:
        return 0
    return ((l & 0x1) | is_left | \
                (
                    (
                        P_list( (l >> 1), (is_left^0x1) )
                    )
                    << 1
                )
    )

def P_l2(l):
    return P_list(l, 1)

ar = []
for i in xrange(1,64):
    mask = 0b1
    for offset in xrange(0, i-1, 2):
        mask |= (0b1 << offset)
    ar.append((1 << i, (~(1 << (i-1))), mask))

# Array index.
a = -1
# Top
t = 0
# high-bitmask
h = 0
# or-bitmask
o = 0

def extract():
    global a
    global t, h, o
    a += 1
    (t, h, o) = ar[a]
    return;

def reset():
    global a
    a = -1
    extract()
    return

reset()

def P_l(l):
    global t, h, o
    while (l >= t):
        extract()
    return ((l & h) | o)

def P(n):
    if n == 1:
        return 1
    if ((n & 0x1) == 1):
        return P(n-1)
    return 1 + P_l(i)

def S(MAX):
    reset()
    s = long(0)
    for i in xrange(2,MAX,2):
        s += P_l2(i)

    s <<= 1

    if ((MAX & 0x1) == 0):
        s += P_l2(MAX)

    s += MAX

    return s

def print_S(MAX):
    print (("S(%d) = %d") % (MAX, S(MAX)))

def S_from_2power_to_next(exp):
    mymin = 1 << exp
    mymax = ((1 << (exp+1)) - 1)

    cnt = (mymax - mymin + 1)
    naive_sum = ( (((mymax&(~mymin))+0) * cnt) >> 1 )
    s = naive_sum
    for b_exp in xrange(0, exp, 2):
        b_pow = 1 << b_exp
        s += ((b_pow * cnt) >> 1)

    # The P... are always -1.
    return s + cnt

if False:
    for i in xrange(2,100001):
        if P_l(i) != P_l2(i):
            print (("P(%d) = %d ; P2(%d) = %d ;" % (i, P_l(i), i, P_l2(i))))
            raise BaseException

reset()
for i in xrange(3, 15):
    expected = S((1 << (1+i))-1) - S((1 << (i))-1)
    got = S_from_2power_to_next(i)
    print (("i=%d got = %d expected = %d") % (i, got, expected))
    if got != expected:
        raise BaseException
    # print (("P(%d) = %d ; P2(%d) = %d ;" % (i, P_l(i), i, P_l2(i))))
# print_S(1000000000)
