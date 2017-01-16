#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::GMP;

use Math::BigInt lib => 'GMP';    #, ':constant';

use List::Util qw(reduce sum);
use List::MoreUtils qw(all);

use Math::ModInt qw(mod);
use Math::ModInt::ChineseRemainder qw(cr_combine cr_extract);

my $MAX = 300000;

# p is the primes
my @p = `primes 2 $MAX`;
chomp(@p);

STDOUT->autoflush(1);

my $sum = 0;
my $m = mod( 1, 2 );

# s = search through.
my $s = [@p];
shift @p;
while ( my ( $i, $P ) = each @p )
{
    print "Reached i=$i\n";
    $m = cr_combine( $m, mod( $i + 2, Math::BigInt->new($P) ) );
    my $A = $m->residue;

    my @n;
    while ( $s->[0] <= $P )
    {
        shift @$s;
    }
    foreach my $p (@$s)
    {
        if ( $A % $p == 0 )
        {
            $sum += $p;
            print "Found p=$p sum=$sum\n";
        }
        else
        {
            push @n, $p;
        }
    }
    $s = \@n;
}

print "Sum == $sum\n";
