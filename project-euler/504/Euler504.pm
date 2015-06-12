package Euler504;

use strict;
use warnings;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $M;
my %cache;

sub set_M
{
    $M = shift;

    %cache = ();

    return;
}

sub calc_tri
{
    my ($x, $y) = sort { $a <=> $b } @_;

    return $cache{"$x,$y"} //= sub {
        # my $dy = $y / $x;

        my $count = 0;
        my $edges = $y + $x - 1;

        for my $i (0 .. $x)
        {
            my $len = $y * $i;
            $count += int($len / $x);
            if ($len % $x)
            {
                $count++;
            }
        }

        return [$count, $edges];
    }->();
}

sub calc_all_quadris
{
    my $ret = 0;

    for my $A (1 .. $M)
    {
        for my $B (1 .. $M)
        {
            print "A,B=$A,$B\n";
            my $AB = calc_tri($A,$B);

            for my $C (1 .. $M)
            {
                my $BC = calc_tri($B,$C);

                my $ABC = [$AB->[0] + $BC->[0],$AB->[1] + $BC->[1]];

                for my $D (1 .. $M)
                {
                    my $CD = calc_tri($C, $D);
                    my $AD = calc_tri($A, $D);

                    # We add 3 for the
                    my $count = $ABC->[0] + $CD->[0] + $AD->[0]
                        - (($ABC->[1] + $CD->[1] + $AD->[1]) >> 1)
                        - 1;

                    my $root = int(sqrt($count));
                    if ($root * $root == $count)
                    {
                        $ret++;
                    }
                }
            }
        }
    }

    return $ret;
}

1;

