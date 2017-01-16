import sys
if sys.version_info > (3,):
    long = int
    xrange = range


def dice(num_faces, n):
    if n == 1:
        return [0] + [1] * num_faces
    else:
        prev = dice(num_faces, n-1)
        ret = [0] * (1 + num_faces * n)
        for i in xrange(1, num_faces+1):
            for j, v in enumerate(prev):
                ret[i+j] += v
        return ret


def main():
    print(dice(6, 3))

if __name__ == "__main__":
    main()
