cache = {(1,False):0,(1,True):0}

def P_list(l, is_left):
    key = (l,is_left)
    if not key in cache:
        cache[key] = (1 if (is_left or ((l & 0x1) != 0)) else 0) + \
                (
                    (
                        P_list( (l >> 1), (not is_left) )
                    )
                    << 1
                )
    return cache[key]

def P(n):
    if n == 1:
        return 1
    if ((n & 0x1) == 1):
        return P(n-1)
    return 1 + P_list(i, True)

for i in range(1,1001):
    print (("P(%d) = %d") % (i, P(i)))
