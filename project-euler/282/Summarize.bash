#!/bin/bash

# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

perl -lanE 'print s/\A[^\(]+//r if m#\AA(?:_mod)?\(([0-6]),\1\) = #' | sort | uniq | perl -lanE '($s += $F[-1]) %= (14 ** 8); END { print $s; }'
