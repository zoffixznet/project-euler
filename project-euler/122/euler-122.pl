#!/usr/bin/perl

use strict;
use warnings;

use integer;

use List::MoreUtils qw(uniq);
use List::Util qw(min);

=head1 DESCRIPTION

The most naive way of computing n15 requires fourteen multiplications:

n × n × ... × n = n15

But using a "binary" method you can compute it in six multiplications:

n × n = n2
n2 × n2 = n4
n4 × n4 = n8
n8 × n4 = n12
n12 × n2 = n14
n14 × n = n15

However it is yet possible to compute it in only five multiplications:

n × n = n2
n2 × n = n3
n3 × n3 = n6
n6 × n6 = n12
n12 × n3 = n15

We shall define m(k) to be the minimum number of multiplications to compute nk;
for example m(15) = 5.

For 1 ≤ k ≤ 200, find ∑ m(k).

=cut

my @combinations = (undef, ['']);

foreach my $n (2 .. 200)
{
    print "Reached $n\n";
    my %sets;

    foreach my $lower (1 .. ($n>>1))
    {
        my $upper = $n - $lower;
        
        foreach my $l_set (@{$combinations[$lower]})
        {
            foreach my $u_set (@{$combinations[$upper]})
            {
                my $s = join(",", uniq(sort { $a <=> $b } (split(/,/,$l_set),split(/,/,$u_set), $n)));
                $sets{$s}++;
            }
        }
    }

    $combinations[$n] = [sort { $a cmp $b } keys(%sets)];
}

my $sum = 0;

foreach my $n (2 .. 200)
{
    $sum += min (map { scalar( my @x = split(/,/, $_)) } @{$combinations[15]});
}
print "Sum = $sum\n";

