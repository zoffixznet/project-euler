import sys

if sys.version_info > (3,):
    long = int


def main():
    STEP = 10000
    with open('S1.txt') as in_:
        with open('S2.txt', 'w') as out_:
            with open('S1.txt') as in10:
                k = 1
                max_k = STEP
                S_k10 = int(in10.readline())
                for l in in_:
                    out_.write('%d\n' % (int(l) + S_k10))
                    k += 1
                    if k == max_k:
                        max_k += STEP
                        S_k10 = int(in10.readline())


if __name__ == "__main__":
    main()
