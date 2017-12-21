# The Expat License
#
# Copyright (c) 2017, Shlomi Fish
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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
            ret.append(ret[-1] ^ (prev[j] if j < len(prev) else 0) ^
                       (prev[j-num_faces] if j >= num_faces else 0))
        return ret


def main():
    this = []
    for n in xrange(1, 27637+1):
        this = dice(5, n, this)
        print("%d\t%d" % (n, this.count(1)))


if __name__ == "__main__":
    main()
