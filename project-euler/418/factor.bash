# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

perl -Mbigint -E 'say 43->bfac' | factor | perl -lapE 's# #\n#g' | sort | uniq -c | grep -v 6041526 | perl -Mbigint -lanE '$N = 392387855098337600; push @x, [reverse@F]; END { $L = $N/2; $U = $N*2;@x=sort {$a->[0]<=>$b->[0]}@x;sub f{my ($i,$n) = @_; return if $n >= $U; if ($i == @x) { if ($n > $L) { say $n; } } else { my $q = $n + 0; for my $j (0 .. $x[$i][1]) { f($i+1,$q); } continue { $q *= $x[$i][0]; } } } f(0, 1); }' | tee f.txt
