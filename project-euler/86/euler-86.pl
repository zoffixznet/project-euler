#!/usr/bin/perl

use strict;
use warnings;

=head1 DESCRIPTION

A spider, S, sits in one corner of a cuboid room, measuring 6 by 5 by 3, and a
fly, F, sits in the opposite corner. By travelling on the surfaces of the room
the shortest "straight line" distance from S to F is 10 and the path is shown
on the diagram.

However, there are up to three "shortest" path candidates for any given cuboid
and the shortest route is not always integer.

By considering all cuboid rooms with integer dimensions, up to a maximum size
of M by M by M, there are exactly 2060 cuboids for which the shortest distance
is integer when M=100, and this is the least value of M for which the number of
solutions first exceeds two thousand; the number of solutions is 1975 when
M=99.

Find the least value of M such that the number of solutions first exceeds one
million.

=cut

use List::Util qw(min);

# my %distance_squares = ();
my $count = 0;
my $M = 1;
while (1)
{
    for my $N (1 .. $M)
    {
        for my $L (1 .. $N)
        {
            my @arr = ($M,$N,$L);
            my $get_dist = sub {
                my $idx = shift;
                my $x = $arr[$idx];
                my $t = $arr[($idx+1)%3] + $arr[($idx+2)%3];
                return ($x*$x+$t*$t);
            };
            my $dist_sq = min(map { $get_dist->($_) } (0 .. $#arr));
            my $dist = sqrt($dist_sq);
            if (int($dist) == $dist)
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
    if ($M == 99)
    {
        if ($count != 1975)
        {
            die "Number of solutions for M == 99 is wrong.";
        }
    }
    else
    {
        if ($count > 1_000_000)
        {
            print "Final[M] = $M\n";
            exit(0);
        }
    }
    $M++;
}
