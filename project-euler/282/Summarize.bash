#!/bin/bash
perl -lanE 'print s/\A[^\(]+//r if m#\AA(?:_mod)?\(([0-6]),\1\) = #' | sort | uniq | perl -lanE '($s += $F[-1]) %= (14 ** 8); END { print $s; }'
