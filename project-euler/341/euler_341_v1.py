import sys

if sys.version_info > (3,):
    long = int
    xrange = range


class Node:
    """docstring for Node"""
    def __init__(self, v, count):
        self.v = v
        self.count = count
        self.next = None
        return


def calc_G(n_s):
    series_G_head = Node(0, 1)
    series_G_tail = Node(1, 1)
    series_G_head.next = series_G_tail
    head_idx = 0
    sum_ = long(1)
    ret = long(0)
    len_ = 2
    i = 0
    for n in n_s:
        piv = n - 1
        while sum_ < piv:
            last = series_G_tail.v
            while head_idx < last:
                series_G_head.count -= 1
                if series_G_head.count == 0:
                    series_G_head = series_G_head.next
                head_idx += 1
            max_count = series_G_head.v
            delta_count = max_count - series_G_tail.count
            delta_sum = delta_count * series_G_tail.v
            if delta_count > 0 and delta_sum + sum_ < piv:
                series_G_tail.count = max_count
                len_ += delta_count
                sum_ += delta_sum
            else:
                if delta_count == 0:
                    series_G_tail.next = Node(last+1, 1)
                    series_G_tail = series_G_tail.next
                else:
                    series_G_tail.count += 1
                len_ += 1
                sum_ += series_G_tail.v
        ret += len_ - (1 if sum_ > piv else 0)
        i += 1
        if ((i & (1024-1)) == 0):
            print("Reached %d ; len_ = %d ; head_idx = %d"
                  % (i, len_, head_idx))
    return ret


def assert_G(n, exp):
    got = calc_G(n)
    print("G(%s) = %d vs %d" % (str(n), got, exp))
    if got != exp:
        raise BaseException("fooblead")
    return


def main():
    assert_G([1], 1)
    assert_G([2], 2)
    assert_G([3], 2)
    assert_G([4], 3)
    assert_G([5], 3)
    assert_G([6], 4)
    assert_G([7], 4)
    assert_G([8], 4)
    assert_G([9], 5)
    assert_G([1000], 86)
    assert_G([1000000], 6137)
    assert_G((n*n*n for n in xrange(1, 1000)), 153506976)
    print("Result = %d" % calc_G((n*n*n for n in xrange(1, 1000000))))


if __name__ == "__main__":
    main()
