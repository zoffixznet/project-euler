cache = {(1,False):0,(1,True):0}

def P_list(L,is_left):
    l = len(L)
    key = (l,is_left)
    if not key in cache:
        rec_L = range(0, l)
        if is_left:
            rec_L = filter(lambda x:(x & 1 == 1), rec_L)
        else:
            last = l - 1
            rec_L = filter(lambda x:(x & 1 != last & 1), rec_L)
        cache[key] = P_list(rec_L, (not is_left))
    pos = cache[key]
    return L[pos]

def P(n):
    if n == 1:
        return 1
    if ((n & 0x1) == 1):
        return P(n-1)
    return P_list((range(1,i+1)), True)

for i in range(1,1001):
    print (("P(%d) = %d") % (i, P(i)))
