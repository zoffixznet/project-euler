#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt ":constant", lib => "GMP";

use lib '.';
use Pentagonal;

use IO::Handle;

STDOUT->autoflush();

# Some analysis. The difference between two consecutive P[n] is:
# P[n+1]-P[n] = [(n+1)(3n+2)-n(3n-1)]/2 = [3n+2n+2+n]/2 = (6n+2)/2 = 3n+1

my @D = ( Pentagonal->new() );
for ( 1 .. 2 )
{
    push @D, $D[-1]->inc();
}

my $P_min_start = Pentagonal->new();

while (1)
{
    while ( $P_min_start->{n} < $D[2]->{n} - $D[0]->{n} )
    {
        print "Incrementing\n";
        $P_min_start = $P_min_start->inc();
    }
    my $P_min      = $P_min_start;
    my $P_min_next = $P_min->inc();
P_MIN_LOOP:
    while (1)
    {
        if ( $P_min_next->{n} - $P_min->{n} > $D[0]->{n} )
        {
            last P_MIN_LOOP;
        }

        # print "D == $D->{n}\nP_min == $P_min->{n}\n";
        my $P_max = $D[0]->{n} + $P_min->{n};

        if ( is_pentagonal($P_max) )
        {
            print "$P_max is pent\n";
            if ( is_pentagonal( $P_max + $P_min->{n} ) )
            {
                print
"P_min == $P_min->{n}\nP_max == $P_max->{n}\nD == $D[0]->{n}\n";
                exit(0);
            }
        }
    }
    continue
    {
        ( $P_min, $P_min_next ) = ( $P_min_next, $P_min_next->inc() );
    }
}
continue
{
    shift(@D);
    push @D, $D[-1]->inc();
}
