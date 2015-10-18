#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';
use Math::GMP qw(:constant);

use List::Util qw(sum);
use List::MoreUtils qw(all);

STDOUT->autoflush(1);

my @p;

my $LIM = 1_000_000_000_000;

open my $p_fh, "primesieve 2 $LIM -p |"
    or die "Cannot open primesieve - $!";

sub get_p
{
    my ($n) = @_;

    while ($#p < $n)
    {
        push @p, (<$p_fh> + 0);
    }

    return $p[$n];
}

my $START = 2;
my $INIT_SUM = ((($LIM - $START) * ($LIM - $START + 1)) >> 1);

print "Init\t$INIT_SUM\n";

my $mul = 1;
for my $i (0 .. 9)
{
    get_p($i);

    my $p = $p[$i];

    my $new_mul = $mul * $p;

    for my $j (1 .. $mul)
    {
        my $check = $j*$p;

        if (all { $check % $_ } @p[0 .. $i-1])
        {
            # Let's Rock and roll
            my $first = $check;

            my $last = ($LIM / $new_mul) * $new_mul + $check;

            if ($last > $LIM)
            {
                $last -= $new_mul;
            }

            my $count = ($last-$first) / $new_mul + 1;

            my $neg_sum = -((($first+$last)*$count) >> 1);
            my $pos_sum = $count * $p;

            print "NegSum[$p,$j]\t$neg_sum\nPositiveSum[$p,$j]\t$pos_sum\n";
        }
    }

    $mul = $new_mul;
}
