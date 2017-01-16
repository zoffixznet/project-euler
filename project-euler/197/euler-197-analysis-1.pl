#!/usr/bin/perl

use strict;
use warnings;

use POSIX qw(floor);

my $mod_u_0 = -1_000_000_000;

sub mod_f
{
    return floor( 2**( 30.403243784 - ( shift() * 1e-9 )**2 ) );
}

my %found;

my $u = $mod_u_0;
my $n = 0;
$found{$u} = $n;
while (1)
{
    my $new_u = mod_f($u);
    if ( ( ++$n ) % 100_000 == 0 )
    {
        print "Reached $n\n";
    }
    print "found[$n] = $new_u\n";
    if ( exists( $found{$new_u} ) )
    {
        print "found[$found{$new_u}] = found[$n]\n";
        exit(0);
    }
    $found{$new_u} = $n;
    $u = $new_u;
}
