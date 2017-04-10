import re
import sys

if sys.version_info > (3,):
    long = int


def main():
    factor_counts = {}
    by_pivots = {}
    l_re = re.compile(r'^[0-9]+: ([0-9 ]+)$')
    with open('./factored.txt') as fh:
        for line in fh:
            l = line.rstrip('\n')
            m = l_re.match(l)
            if not m:
                raise BaseException
            factors = m.group(1).split(' ')
            for f in factors:
                if f not in factor_counts:
                    factor_counts[f] = 0
                factor_counts[f] += 1
            pivot = factors[-1]
            if pivot not in by_pivots:
                by_pivots[pivot] = []
            by_pivots[pivot].append(l)
    for pivot, numbers in by_pivots.iteritems():
        filtered = []
        for l in numbers:
            if all(factor_counts[x] > 2 for x
                   in l_re.match(l).group(1).split(' ')):
                filtered.append(l)
        if len(filtered) > 0:
            with open('./by-pivot-factor/%s.txt' % (pivot), 'w') as o:
                for l in filtered:
                    o.write(l + "\n")
    return


if __name__ == "__main__":
    main()
