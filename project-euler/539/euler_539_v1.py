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

def P_l(l):
    return P_list(l, 1)

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

print_S(1000000000)
