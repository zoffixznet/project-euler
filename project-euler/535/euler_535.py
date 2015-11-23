#!/usr/bin/env python3
import math
import sys
if sys.version_info > (3,):
    long = int

class ArithSeq:
    def __init__(self):
        self.i = 1

    # The next element.
    def n(self):
        ret = self.i
        self.i += 1
        return ret

class FracSeq:
    def __init__(self):
        self._a = ArithSeq()
        self._q = [['a',1,0],['f',1,1]]
        self._f = False

    def n(self):
        first = self._q[0]
        (which, count, peek) = first[0], first[1], first[2]
        if (count == 0):
            if (which == 'f'):
                if (not self._f):
                    self._f = FracSeq()
                    self._f.n()
                new_peek = self._f.n()
                self._q.append(['a', long(math.sqrt(new_peek)), 0])
                self._q.append(['f', 1, new_peek])
            self._q.pop(0)
            return self.n()
        first[1] -= 1
        if (which == 'a'):
            return self._a.n()
        else:
            return peek


f = FracSeq()

for i in range(0,20):
    print (f.n())
