#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

my $LIM = eval( "2" . '0' x 15 );
my $S   = 80846691;
my $M   = $LIM % $S;
my $T   = int( $LIM / $S );
my $U   = $T + 1;

# Result
my $R = 0;

open my $in, '<', 'sums.txt';
while ( my $l = <$in> )
{
    if ( my ( $s, $p ) = $l =~ m#\Ap\[([0-9]+)\] = ([0-9]+)\n# )
    {
        $R += $p * ( $s <= $M ? $U : $T );
    }
}
close($in);

print "Result = $R\n";
