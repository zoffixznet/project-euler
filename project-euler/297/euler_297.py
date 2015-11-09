#!/usr/bin/env python3
import sys
if sys.version_info > (3,):
    long = int

fibs = [long(1), long(2)]

fib_limit = long("1" + ("0" * 17))
while fibs[-1] < fib_limit:
    fibs.append(fibs[-1]+fibs[-2])

