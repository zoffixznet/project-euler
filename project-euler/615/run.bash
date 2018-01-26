# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

seq 1 3000000 | factor | perl -lanE 'use strict; use warnings; my $l = $_; my $number = (shift@F) =~ s/:\z//r; my %h = (); $h{$_}++ for @F; my $two = delete($h{2}) // 0; use List::Util qw/sum/; my $e = ((sum values%h) // 0); for my $i (0 .. ($two ? 0 : $e)) { say(($number / 2 ** $i), " $number ", join " ", sort { $a <=> $b } ((2) x $two, ((-2) x $i), map { ($_) x $h{$_} } keys%h)); } ' | tee l1.txt
