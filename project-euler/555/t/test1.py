#!/usr/bin/python

import sys
import os

sys.path.insert(0, '.')

from TAP.Simple import *

from euler555 import M_func

plan(3)

def main():
    M_91 = M_func(100,11,10)

    # TEST
    is_ok(M_91.calc(101), 91, "M[91](101) == 91")

    # TEST
    is_ok(M_91.calc(91), 91, "M[91](91) == 91")

    # TEST
    ok(M_91.calc_F() == [91], "calc_F");

#----------------------------------------------------------------------

if __name__ == "__main__":
    main()

