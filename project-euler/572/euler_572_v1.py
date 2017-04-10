import sys

if sys.version_info > (3,):
    long = int
    xrange = range

# a b c
# d e f
# g h i


def main(n):
    two_cells_prod = {}
    for b in xrange(-n, n+1):
        print("b=%d" % (b))
        for d in xrange(n+1):
            prod = b*d
            if prod not in two_cells_prod:
                two_cells_prod[prod] = []
            two_cells_prod[prod].append([b, d])
    two_prods_of_two_cells = {}
    MAX = n * n - n
    my_keys = sorted(two_cells_prod.keys())
    my_keys = my_keys[::-1]
    for b_d in my_keys:
        print("b_d=%d" % (b_d))
        # We don't need to consider the negatives due to the duality of
        # the inner loop and because both cannot be negative.
        if b_d < 0:
            break
        for c_g in my_keys:
            s = b_d + c_g
            # a * a - a >= 0 for all a.
            if s < 0:
                break
            if s <= MAX:
                if s not in two_prods_of_two_cells:
                    two_prods_of_two_cells[s] = []
                two_prods_of_two_cells[s].append(
                    [two_cells_prod[b_d], two_cells_prod[c_g]])

    for a in xrange(-n, n+1):
        diff = a*a - a
        if diff in two_prods_of_two_cells:
            for i in two_prods_of_two_cells[diff]:
                for x in i[0]:
                    for y in i[1]:
                        print("%d: %d*%d+%d*%d" % (a, x[0], x[1], y[0], y[1]))


if __name__ == '__main__':
    main(int(sys.argv[1]))
