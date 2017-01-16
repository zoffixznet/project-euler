#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(min);

# my %distance_squares = ();
my $count = 0;
my $M     = 1;
while (1)
{
    for my $N ( 1 .. $M )
    {
        for my $L ( 1 .. $N )
        {
            # my @arr = ($M,$N,$L);
            # my $get_dist = sub {
            #     my $idx = shift;
            #     my $x = $arr[$idx];
            #     my $t = $arr[($idx+1)%3] + $arr[($idx+2)%3];
            #     return ($x*$x+$t*$t);
            # };
            # print join(',',map { $get_dist->($_) } (0 .. $#arr)), "\n";
            # my $dist_sq = min(map { $get_dist->($_) } (0 .. $#arr));
            my $dist_sq = $M * $M + ( $N + $L )**2;
            my $dist = sqrt($dist_sq);
            if ( int($dist) == $dist )
            {
                $count++;
            }

            # $distance_squares{$dist_sq} = 1;
        }
    }
}
continue
{
    print "Checked M=$M Count=$count\n";
    if ( $M == 99 )
    {
        if ( $count != 1975 )
        {
            die "Number of solutions for M == 99 is wrong.";
        }
    }
    else
    {
        if ( $count > 1_000_000 )
        {
            print "Final[M] = $M\n";
            exit(0);
        }
    }
    $M++;
}
