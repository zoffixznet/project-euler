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

def main():
    x4 = transform(4, [0,1])
    x6 = transform(6, x4)
    x8 = transform(8, x6)
    x12 = transform(12, x8)
    x20 = transform(20, x12)
    print("I = ", x20)

if __name__ == "__main__":
    main()
