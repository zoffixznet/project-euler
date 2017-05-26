import sys

if sys.version_info > (3,):
    long = int
    xrange = range


def main():
    for n in xrange(1, 100000000000+1):
        print(n**15 + 1)


if __name__ == "__main__":
    main()
