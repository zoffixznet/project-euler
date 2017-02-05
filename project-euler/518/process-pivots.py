import re
import os
import sys

if sys.version_info > (3,):
    long = int
    xrange = range


def main():
    nums = {}
    with open('primes.txt') as fh:
        for l in fh:
            nums[1+int(l)] = True

    re_f = re.compile('^([0-9]+)\.txt$');
    total_sum = long(0)
    for fn in os.listdir('by-pivot-factor'):
        t = re_f.match(fn)
        if t:
            pivot = int(t.group(1))
            print("Handling %d" % (pivot))
            local_n = []
            with open('by-pivot-factor/' + fn) as fh:
                for x in fh:
                    local_n.append(int(x.split(':')[0]))
            for r in local_n:
                sq = r * r
                l = {}
                for x in local_n:
                    l[x] = False
                for i in local_n:
                    if i != r:
                        j, m = divmod(sq, i)
                        if m == 0:
                            if j in nums:
                                is_local = (j in l)
                                if not (is_local and l[j]):
                                    if is_local:
                                        l[j] = True
                                    print("Found %d,%d,%d" % (i,r,j))
                                    total_sum += ((i+r+j)-3);
    print("Total sum = %d" % total_sum)
    return

if __name__ == "__main__":
    main()
