#!/usr/bin/perl

use strict;
use warnings;

use lib '.';
use Row;

sub S
{
    my ($i) = @_;

    my $row = Row->new( { idx => $i } );
    $row->mark_primes;

    return $row->calc_S;
}

print "The solution is ", S(5678027) + S(7208785), "\n";
