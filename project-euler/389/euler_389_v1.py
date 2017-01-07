import sys
if sys.version_info > (3,):
    long = int
    xrange = range

def transform(s, l):
    ret = [0] * (1 + s * (len(l)-1))
    prev = [1]
    for i, v in enumerate(l):
        if i > 0:
            new = [0] * (1 + s * i)
            for faceval in xrange(1,s+1):
                for idx, val in enumerate(prev):
                    new[idx+faceval] += val
            if v > 0:
                for idx, val in enumerate(new):
                    ret[idx] += val * v
            prev = new
    # while ret[-1] == 0:
    #     ret.pop()
    print "s = ", s, " ; ret = ", ret
    sys.stdout.flush()
    return ret

def calc_variance(x12):
    from bigfloat import precision, BigFloat
    # x12 = [0,1]
    with precision(100000):
        n = 0
        s = 0
        s_sq = BigFloat(0)
        this_base_n = long(1)
        base_s_sq = sum([x*x for x in xrange(1,20+1)])
        base_s = sum([x for x in xrange(1,20+1)])
        base_var = BigFloat(base_s_sq)/20 - BigFloat(base_s * base_s)/20/20
        for i, v in enumerate(x12):
            n += this_base_n * v
            s += ((this_base_n * v * i * (1+20))>>1)
            var = base_var * i
            var_less = var + BigFloat(base_s * base_s * i * i)/20/20
            sq = var_less * this_base_n
            s_sq += sq * v
            this_base_n *= 20
        # print("I = ", x20)
        # print 's_sq,s,n  = %f,%f,%f' % (s_sq,s,n)
        return ((BigFloat(s_sq) / BigFloat(n)) - ((BigFloat(s)/BigFloat(n)) ** 2))

def calc_variance_brute(x12):
    from bigfloat import precision, BigFloat
    with precision(100000):
        s_sq = [0, 0, 0]
        for i, v in enumerate(x12):
            if i > 0:
                print "i = ", i
                def rec(s_sq, sum_, c):
                    if (c == i):
                        s_sq[0] += v * sum_ * sum_
                        s_sq[1] += v * sum_
                        s_sq[2] += v
                    else:
                        for x in xrange(1,21):
                            rec(s_sq, sum_+x, c+1)
                rec(s_sq, 0,0)
        print "s_sq = ", s_sq
        return (BigFloat(s_sq[0])/BigFloat(s_sq[2]) - ((BigFloat(s_sq[1])/BigFloat(s_sq[2]))**2))

def both(x12):
    print "\n\n=========\n\n"
    print "x12 = ", x12
    print "Good: %f" % calc_variance_brute(x12)
    print "Fast: %f" % calc_variance(x12)
    return

def transform_brute(s, l):
    ret = [0] * (1 + s * (len(l)-1))
    for i, v in enumerate(l):
        if i == 0:
            continue
        def rec(sum_, c):
            if i == c:
                ret[sum_] += v
            else:
                for x in xrange(1,s+1):
                    rec(sum_+x,c+1)
        rec(0,0)
    return ret

def transform_both(s, l):
    good = transform_brute(s, l)
    fast = transform(s, l)
    if good != fast:
        raise BaseException("Foo")
    return fast

def main():
    x4 = transform_both(4, [0,1])
    x6 = transform_both(6, x4)
    transform_both(12, [0,1,2])
    transform_both(12, [0,1,4,1])
    transform_both(12, [0,1,4,8])
    x8 = transform(8, x6)
    x12 = transform(12, x8)
    # x20 = transform(20, x12)
        # print ("Result = %.4f" % var)
    both([0,1])
    both([0,2])
    both([0,0,1])
    both([0,0,0,1])
    both([0,1,1])
    both([0,2,1])
    both([0,2,2])
    both([0,2,2,5])
    both([0,2,2,5,10,9])
    print "x12: %.4f" % calc_variance(x12)

if __name__ == "__main__":
    main()
