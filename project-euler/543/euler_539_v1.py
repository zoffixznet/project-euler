import math
import sys
from subprocess import Popen, PIPE

if sys.version_info > (3,):
    long = int

fibs = [long(0),long(1)]

while len(fibs) < 45:
    fibs.append(fibs[-1] + fibs[-2])

print(fibs)
