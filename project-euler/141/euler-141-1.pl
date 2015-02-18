#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(first);

STDOUT->autoflush(1);

my $sum = 0;

N:
for my $n_root (1 .. (1_000_000 - 1))
{
    my $n = ($n_root * $n_root);

=begin removed
    # TODO : Remove later.
    if ($n >= 100_000)
    {
        last N;
    }
=end removed

=cut

    R:
    for my $r (1 .. $n)
    {
        my $prod = $r * ($n-$r);
        my $d_guess = $prod ** (1/3);

        if ($d_guess <= $r)
        {
            last R;
        }

        my $d = first { $_ * $_ * $_ == $prod } (int($d_guess)-1 .. int($d_guess)+1);
        if (defined($d))
        {
            my $q = int($n / $d);
            my $r_new = ($n % $d);
            if ($r_new == $r)
            {
                my @seq = (sort { $a <=> $b } ($q,$d,$r));
                if ($seq[1] *$seq[1] == $seq[0]*$seq[2])
                {
                    $sum += $n;
                    print "Found Intermediate sum[n=$n] = $sum\n";
                    last R;
                }
            }
        }
    }
    print "Intermediate sum[n_root=$n_root] = $sum\n";
}

print "Final sum = $sum\n";
