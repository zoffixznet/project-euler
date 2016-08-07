#!/bin/bash

/home/shlomif/Download/unpack/prog/python/pypy2-v5.3.0-src/pypy/goal/pypy-c euler_565_v1.py | sort -n -u | perl -lanE '$s += $_; END{ say $s; }'
