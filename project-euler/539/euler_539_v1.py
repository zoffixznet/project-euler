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

def P(n):
    if n == 1:
        return 1
    if ((n & 0x1) == 1):
        return P(n-1)
    return 1 + P_list(i, True)

s = 0
for i in xrange(1,1000000001):
    s += P(i)
print s
