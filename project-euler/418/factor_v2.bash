# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

perl -Mbigint -E 'say 43->bfac' | factor | perl -lapE 's# #\n#g' | sort | uniq -c | grep -v 6041526 | /home/shlomif/Download/unpack/prog/python/pypy2-v5.7.1-src/pypy/goal/pypy-c fhelp.py | tee f2.txt
sort -n < f2.txt > f3.txt
