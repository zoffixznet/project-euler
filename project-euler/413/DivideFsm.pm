package DivideFsm;

use strict;
use warnings;

sub get_div_fsms
{
    my $BASE = shift;

    my @states;

    my @rev_states;
    for my $i ( 0 .. $BASE - 1 )
    {
        my @links = map { ( $i * 10 + $_ ) % $BASE } 0 .. 9;

        for my $l_idx ( keys(@links) )
        {
            $rev_states[ $links[$l_idx] ][$l_idx] = $i;
        }
        push @states, \@links;
    }

    return ( \@states, \@rev_states );
}

1;
