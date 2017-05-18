import sys
import math
from six import print_

if sys.version_info > (3,):
    xrange = range


def main():
    ret = ['2', ]
    fn = 'P_1M.txt'
    cnt = 1
    n = 3
    GOAL = 1000000
    while cnt < GOAL:
        is_prime = True
        for x in xrange(3, int(math.sqrt(n))+1, 2):
            if (n % x == 0):
                is_prime = False
                break
        if is_prime:
            cnt += 1
            ret.append(str(n))
            if cnt % 1000 == 0:
                print_('Reached %d out of %d' % (cnt, GOAL))
        n += 2
    print_('Writing')
    with open(fn, 'wb') as fh:
        for c in ret[::-1]:
            fh.write(c[::-1])
    print_('Finished writing')


if __name__ == "__main__":
    main()
