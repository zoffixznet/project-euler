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
    if (MAX == 0):
        return 0
    reset()
    s = long(0)
    for i in xrange(2,MAX,2):
        s += P_l(i)

    s <<= 1

    if ((MAX & 0x1) == 0):
        s += P_l(MAX)

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

def brute_force__prefix_S_from_2power_to_next(prefix, exp):
    mymin = prefix << exp
    mymax = mymin + ((1 << exp) - 1)
    return S(mymax) - S(mymin-1)

def prefix_S_from_2power_to_next(prefix, exp):
    mymin = prefix << exp
    mymax = mymin + ((1 << exp) - 1)

    cnt = (mymax - mymin + 1)

    mymask = mymin
    b_exp = 0
    b_pow = 1
    while b_exp < exp:
        b_exp += 2
        b_pow <<= 2
    while b_pow < mymin:
        mymask |= b_pow
        b_exp += 2
        b_pow <<= 2

    b_pow = 1
    while b_pow <= mymask:
        b_pow <<= 1

    mymask &= (~(b_pow >> 1));

    return S_from_2power_to_next(exp) + mymask * cnt

if False:
    for i in xrange(2,100001):
        if P_l(i) != P_l2(i):
            print (("P(%d) = %d ; P2(%d) = %d ;" % (i, P_l(i), i, P_l2(i))))
            raise BaseException

reset()
if True:
    for i in xrange(0, 15):
        expected = S((1 << (1+i))-1) - S((1 << (i))-1)
        got = S_from_2power_to_next(i)
        print (("i=%d got = %d expected = %d") % (i, got, expected))
        if got != expected:
            raise BaseException
        # print (("P(%d) = %d ; P2(%d) = %d ;" % (i, P_l(i), i, P_l2(i))))
    # print_S(1000000000)

if False:
    for prefix in [0b10, 0b100, 0b11,0b101,0b1001,0b1101,0b111,0b1011,0b1111]:
        for exp in xrange(1,15):
            expected = brute_force__prefix_S_from_2power_to_next(prefix, exp)
            got = prefix_S_from_2power_to_next(prefix, exp)
            print (("prefix=%d exp=%d got=%d expected=%d") % (prefix, exp, got, expected))
            if got != expected:
                raise BaseException

def fast_S(MAX):
    s = long(S(1))
    mymin = long(2)
    mymax = long(3)
    b_exp = long(1)
    while mymax < MAX:
        s += S_from_2power_to_next(b_exp)
        mymin <<= 1
        b_exp += 1
        mymax = ((mymin << 1) - 1)

    reset()
    s += 1 + P_l(mymin)

    digit = mymin >> 1
    b_exp -= 1
    # mymin is what we reached.
    while mymin < MAX:
        new_mymin = (mymin | digit)
        if (new_mymin <= MAX):
            res = prefix_S_from_2power_to_next(mymin >> b_exp, b_exp)
            s += res
            reset()
            s += P_l(new_mymin) - P_l(mymin)
            mymin = new_mymin
        digit >>= 1
        b_exp -= 1

    if mymin < MAX:
        reset()
        s += 1 + P_l(MAX)

    return s

if True:
    for i in xrange(5, 1000):
        expected = S(i)
        got = fast_S(i)
        print (("S : i=%d got = %d expected = %d") % (i, got, expected))
        if got != expected:
            raise BaseException

myMAX = long('1000000000000000000')
myRES = fast_S(myMAX)
print ("S(%d) = %d (mod = %d)" % (myMAX, myRES, myRES % 987654321))
