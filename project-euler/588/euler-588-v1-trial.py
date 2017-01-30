import sys
if sys.version_info > (3,):
    long = int
    xrange = range


def dice(num_faces, n, prev):
    if n == 1:
        return [1] * num_faces
    else:
        ret = [0] * (1 + num_faces * n)
        for i in xrange(0, num_faces):
            for j, v in enumerate(prev):
                ret[i+j] ^= v
        return ret


def main():
    this = []
    for n in xrange(1, 300):
        this = dice(5, n, this)
        print("%d\t%d" % (n, len([x for x in this if x % 2 == 1])))


if __name__ == "__main__":
    main()
