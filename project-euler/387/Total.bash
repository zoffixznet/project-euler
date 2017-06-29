#!/bin/bash
/home/shlomif/Download/unpack/prog/python/pypy2-v5.7.1-src/pypy/goal/pypy-c euler_387_v1.py | factor | perl -lnE '$s+=$1, say $_ if /\A([0-9]+): \1\z/;END{say$s}'
