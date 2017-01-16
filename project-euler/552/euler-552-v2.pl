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

my $MAX    = 300000;
my @primes = `primes 2 $MAX`;
chomp(@primes);

STDOUT->autoflush(1);

my $sum = 0;
my $m = mod( 1, 2 );
my %f;
my @s = @primes;
for my $idx ( 1 .. $#primes )
{
    my $P = $primes[$idx];
    print "Reached i=$idx\n";
    $m = cr_combine( $m, mod( $idx + 1, Math::BigInt->new($P) ) );
    my $A = $m->residue;

    my @n;
    while ( $s[0] <= $P )
    {
        shift @s;
    }
    foreach my $p (@s)
    {
        if ( $A % $p == 0 )
        {
            $sum += $p;
            $f{$p} = 1;
            print "Found p=$p sum=$sum\n";
        }
        else
        {
            push @n, $p;
        }
    }
    @s = @n;
}

print "Sum == $sum\n";
