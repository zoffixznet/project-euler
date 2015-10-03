#!/bin/bash
perl -lanE 'print if m#\AA(?:_mod)?\(([0-6]),\1\) = #' | grep -vP '^A\(4,4\)' | perl -lanE '($s += $F[-1]) %= (14 ** 8); END { print $s; }'
