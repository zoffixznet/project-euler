#!/usr/bin/python

import sys
import os

sys.path.insert(0, '.')

from TAP.Simple import *

from euler555 import M_func, S_func

plan( 5 )

def main():
    M_91 = M_func(100,11,10)

    # TEST
    is_ok(M_91.calc(101), 91, "M[91](101) == 91")

    # TEST
    is_ok(M_91.calc(91), 91, "M[91](91) == 91")

    # TEST
    ok(M_91.calc_F() == [91], "calc_F");

    # TEST
    ok(M_91.calc_SF() == long(91), "calc_SF");

    # TEST
    ok(S_func(10, 10).calc() == long(225), "S(10,10)");

#----------------------------------------------------------------------

if __name__ == "__main__":
    main()

