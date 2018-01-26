# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

seq 2 $(perl -E 'say 1e12') | factor | perl -lanE 'BEGIN { STDERR->autoflush(1); } /: ([0-9]+)/ and ($s = ($s+$1)%1_000_000_000); print STDERR "n = $. ; s = $s\n" if $. % 10_000_000 == 0; END { print "S = $s\n" }'
