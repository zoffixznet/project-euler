#!/bin/bash
perl -lanE 'print if m#\AA(?:_mod)?\(([0-6]),\1\) = #' | perl -lanE '($s += $F[-1]) %= (14 ** 8); END { print $s; }'
