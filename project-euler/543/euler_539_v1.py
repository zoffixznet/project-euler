import math
import sys
import re
from subprocess import Popen, PIPE, check_output

if sys.version_info > (3,):
    long = int

def count_primes_up_to(n):
    out = check_output(["primesieve", str(n), "-c1"])
    m = re.search(r'Prime numbers\s*:\s*([0-9]+)', out)
    return long(m.group(1));

def calc_s(n):
    if n == 2:
        return len([2])
    if n == 3:
        return len([2,3])
    if n == 5:
        return len([2,3,5,2+2,2+3])
    # Calc s[k=1].
    s_1 = count_primes_up_to(n)
    # Calc s[k=2] for i odd.
    s_2 = count_primes_up_to((n & (~0x1))-1-2)-1
    # Calc the higher s-s for even numbers.
    first_even_s = ((n & (~0x1)) - 6) >> 1
    last_even_s = 0
    count_even_s = ((first_even_s - last_even_s) + 1)
    even_s = ((first_even_s + last_even_s) * count_even_s) >> 1
    # Calc the higher s-s for odd numbers.
    first_odd_s = ( (n if ((n & 0x1) == 1) else n-1) - 1 ) >> 1
    last_odd_s = 0
    count_odd_s = ((first_odd_s - last_odd_s) + 1)
    odd_s = ((first_odd_s + last_odd_s) * count_odd_s) >> 1

    return s_1 + s_2 + even_s + odd_s

fibs = [long(0),long(1)]

while len(fibs) < 45:
    fibs.append(fibs[-1] + fibs[-2])

print(fibs)

def print_s(n):
    print (("S[%d] = %d" % (n, calc_s(n))))

print_s(10)
print_s(100)
print_s(1000)

print ("Result = %d" % (sum([calc_s(fibs[k]) for k in range(3,45)])))
