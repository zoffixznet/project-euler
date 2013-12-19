#!/usr/bin/perl

use strict;
use warnings;
use Math::BigInt lib => 'GMP', ':constant';
use List::MoreUtils qw(all indexes true);
use List::Util qw(sum);

my @counts;

sub update_count
{
    my ($depth, $penult, $ultimate, $diff) = @_;

    ($counts[$depth][$penult][$ultimate] //= 0) += $diff;

    return;
}

sub list_digits
{
    my ($depth, $penult) = @_;

    return [indexes { defined } @{$counts[$depth-1][$penult]}];
}

sub get_count
{
    my ($depth, $penult, $ultimate) = @_;

    return $counts[$depth-1][$penult][$ultimate];
}

# Initialize $depth = 2;
#
my $INIT_DEPTH = 2;
for my $penult (1 .. 9)
{
    for my $ult (0 .. (9-$penult))
    {
        update_count($INIT_DEPTH, $penult, $ult, 1);
    }
}

my $MAX_DEPTH = 20;
for my $depth ($INIT_DEPTH+1 .. $MAX_DEPTH)
{
    for my $penult (0 .. 9)
    {
        for my $ult (@{list_digits($depth, $penult)})
        {
            for my $new (0 .. (9-($penult+$ult)))
            {
                # print "D=$depth $penult$ult$new\n";
                # STDOUT->flush;
                update_count($depth, $ult, $new,
                    get_count($depth, $penult, $ult)
                );
            }
        }
    }

    my $sum = sum(map { $_ // 0 } map { @{$_ // []} } @{$counts[$depth]});
    print "Sum for depth=$depth = $sum\n";

    if (0)
    {
        my $verify = sub {
            my ($n) = @_;

            return all { sum(split//,substr($n, $_, 3)) <= 9 } (0 .. (length($n)-3));
        };
        my $verify_sum =
            true { $verify->("$_") }
            ((10 ** ($depth-1)) .. (10 ** $depth - 1))
            ;
        print "VerifySum for depth=$depth = $verify_sum\n";
    }
}
