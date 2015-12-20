cache = {(1,False):0,(1,True):0}

def P_list(l, is_left):
    key = (l,is_left)
    if not key in cache:
        rec_l = (l >> 1)
        # rec_start = start + (step if (is_left or ((l & 0x1) != 0)) else 0)
        rec_start = 0 + (1 if (is_left or ((l & 0x1) != 0)) else 0)
        rec_step = 2
        cache[key] = rec_start + rec_step * P_list(rec_l, (not is_left))
    return cache[key]

def P(n):
    if n == 1:
        return 1
    if ((n & 0x1) == 1):
        return P(n-1)
    return 1 + P_list(i, True)

for i in range(1,1001):
    print (("P(%d) = %d") % (i, P(i)))
