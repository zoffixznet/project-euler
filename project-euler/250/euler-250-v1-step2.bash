#!/bin/bash

# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

perl -lanF'/:\s*/' -E 'push @{$h{$F[1]}}, $F[0]; END { print for map { join(" ", $_, @{$h{$_}}) } sort { $a <=> $b } keys%h }'
