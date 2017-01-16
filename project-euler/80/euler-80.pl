#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(sum);

use Euler80;

sub square_root_digits_sum
{
    my $n = shift;

    my $result = Euler80::square_root($n);
    my $first_100 = substr( "$result", 0, 100 );
    return sum( split //, $first_100 );
}

my %squares = ( map { ( $_ * $_ ) => 1 } ( 1 .. 100 ) );
my $total_sum = 0;

for my $n ( 1 .. 100 )
{
    print "Reached $n\n";
    if ( !exists( $squares{$n} ) )
    {
        $total_sum += square_root_digits_sum($n);
    }
    print "Total sum = $total_sum\n";
}
print $total_sum, "\n";
