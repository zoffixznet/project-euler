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

for i in xrange(2,100001):
    if P_l(i) != P_l2(i):
        print (("P(%d) = %d ; P2(%d) = %d ;" % (i, P_l(i), i, P_l2(i))))
        raise BaseException
    # print (("P(%d) = %d ; P2(%d) = %d ;" % (i, P_l(i), i, P_l2(i))))
# print_S(1000000000)
