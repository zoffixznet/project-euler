import sys
if sys.version_info > (3,):
    long = int
    xrange = range


def dice(num_faces, n, prev):
    if n == 1:
        return [1] * num_faces
    else:
        if False:
            ret = [0] * (1 + num_faces * n)
            for i in xrange(num_faces):
                for j, v in enumerate(prev):
                    ret[i+j] ^= v
        ret = [prev[0]]
        for j in xrange(1, len(prev)+num_faces-1):
            ret.append(ret[-1] ^ (prev[j] if j < len(prev) else 0)
                       ^ (prev[j-num_faces] if j >= num_faces else 0))
        return ret


def main():
    this = []
    for n in xrange(1, 27637+1):
        this = dice(5, n, this)
        print("%d\t%d" % (n, this.count(1)))


if __name__ == "__main__":
    main()
