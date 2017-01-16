use strict;
use warnings;

use List::MoreUtils (qw(all));

my %Cache = ( 1 => 0 );

sub num_distinct_factors_helper
{
    my ( $n, $start_from ) = @_;

    if ( not exists( $Cache{$n} ) )
    {
        my $d = $n;
        while ( $d % $start_from )
        {
            $start_from++;
        }
        while ( $d % $start_from == 0 )
        {
            $d /= $start_from;
        }
        $Cache{$n} = 1 + num_distinct_factors_helper( $d, $start_from + 1 );
    }
    return $Cache{$n};
}

sub num_distinct_factors
{
    return num_distinct_factors_helper( $_[0], 2 );
}

for my $n ( 14 .. 100_000 )
{
    print "$n\n" if ( $n % 1000 == 0 );
    if ( all { num_distinct_factors($_) >= 4 } ( $n .. $n + 2 ) )
    {
        print "n = $n\n";
        exit;
    }
}
