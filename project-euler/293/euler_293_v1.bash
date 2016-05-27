#!/bin/bash
# primes 2 | perl -nalE 'BEGIN {$p = 1;}; say "$_ ", (1_000_000_000 - ($p *= $_));'
export PRIMES="$(primes 2 23)"

adm()
{
    perl -lE 'my @p = split/\s+/ , $ENV{PRIMES}; sub rec { my ($m, $i) = @_; if ($i >= @p) { return;} ; $m *= $p[$i]; while ($m < 1_000_000_000) { say $m ; rec($m, $i+1); $m *= $p[$i]; }; return; } rec(1,0);' | sort -n
}

my_primes()
{
    primes 2 1000000007
}

perl -l -MList::Util=sum -E 'my %h; open my $adm, "<", shift; open my $p_fh, "<", shift; my $p; sub _next_p { $p = <$p_fh>;chomp$p;} _next_p(); while (chomp(my $l = <$adm>)) { while ($p <= $l+1) { _next_p(); } ; $h{$p - $l} = 1; } say sum keys %h' <(adm) <(my_primes)
