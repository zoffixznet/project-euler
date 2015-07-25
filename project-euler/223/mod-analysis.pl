#!/usr/bin/perl

use strict;
use warnings;

for my $BASE (2 .. 80)
{
    for my $A (0 .. $BASE-1)
    {
        my $mod_Asq = (($A * $A) % $BASE);

        for my $B (0 .. $BASE-1)
        {
            my $mod_Bsq = (($B * $B) % $BASE);

            for my $C (0 .. $BASE-1)
            {
                my $mod_Csq = (($C * $C + 1) % $BASE);

                if (($mod_Asq + $mod_Bsq) % $BASE == $mod_Csq)
                {
                    print "$BASE: A=$A,B=$B,C=$C\n";
                }
            }
        }
    }
}
