#!/usr/bin/python

import sys
from TAP.Simple import diag, is_ok, ok, plan
from euler555 import M_func, S_func

if sys.version_info > (3,):
    long = int

plan(6)


def eq_ok(have, want, blurb):
    ret = ok(have == want, blurb)
    if (not ret):
        diag("(have = '%s', want = '%s')" % (have, want))
    return ret


def main():
    M_91 = M_func(100, 11, 10)

    # TEST
    is_ok(M_91.calc(101), 91, "M[91](101) == 91")

    # TEST
    is_ok(M_91.calc(91), 91, "M[91](91) == 91")

    # TEST
    ok(M_91.calc_F() == [91], "calc_F")

    # TEST
    ok(M_91.calc_SF() == long(91), "calc_SF")

    # TEST
    eq_ok(S_func(10, 10).calc(), long(225), "S(10,10)")

    # TEST
    eq_ok(S_func(1000, 1000).calc(), long(208724467), "S(1000,1000)")


if __name__ == "__main__":
    main()
