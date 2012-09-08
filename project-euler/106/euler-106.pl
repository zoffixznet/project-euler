#!/usr/bin/perl

use strict;
use warnings;

sub recurse
{
    my ($B, $C, $remaining) = @_;

    if (! @$remaining)
    {
        if (@$B && @$C)
        {
            # print "[@$B],[@$C]\n";
            if (@$B == @$C and @$B != 1)
            {
                my $ok = 1;
                COMPARE:
                for my $i (0 .. $#$B)
                {
                    if ($B->[$i] > $C->[$i])
                    {
                        $ok = 0;
                        last COMPARE;
                    }
                }

                if (!$ok)
                {
                    print "[@$B],[@$C]\n";
                }
            }
        }
    }
    else
    {
        my ($first, @others) = @$remaining;
        recurse($B,$C,\@others);
        recurse([@$B,$first],$C,\@others);
        if (@$B)
        {
            recurse($B,[@$C,$first],\@others);
        }
    }

    return;
}

recurse([],[],[1..12]);
