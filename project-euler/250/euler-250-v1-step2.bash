#!/bin/bash
perl -lanF'/:\s*/' -E 'push @{$h{$F[1]}}, $F[0]; END { print for map { join(" ", $_, @{$h{$_}}) } sort { $a <=> $b } keys%h }'
