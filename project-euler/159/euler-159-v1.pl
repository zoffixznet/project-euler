#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(max sum);
use List::MoreUtils qw();

my @drs;
my @factors;

sub _digi_root
{
    my ($n) = @_;

    my $ret = sum( split //, $n );

    if ( $ret >= 10 )
    {
        $ret = _digi_root($ret);
    }

    return $ret;
}

my $MAX = 999_999;
my $sum = 0;
for my $n ( 2 .. $MAX )
{
    my $f = $factors[$n];

    # If $n is prime.
    my $result = _digi_root($n);
    if ( defined($f) )
    {
        $result = max( $result, map { $drs[$_] + $drs[ $n / $_ ] } @$f );
    }
    $sum += ( $drs[$n] = $result );

    my $product = $n * $n;
    while ( $product <= $MAX )
    {
        push @{ $factors[$product] }, $n;
    }
    continue
    {
        $product += $n;
    }
    print "Reached N=$n Sum=$sum\n";
}
