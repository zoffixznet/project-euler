#!/usr/bin/perl

use strict;
use warnings;

use 5.022;

no warnings 'recursion';

sub pow
{
    my ($b, $e) = @_;

    my $r = 1;
    foreach my $x (1 .. $e)
    {
        $r *= $b;
    }
    return $r;
}

# my $LIM = 1_000_000_000_000_000;
my $LIM = 1_000_000;
# my $LIM = 100;

my $SQ = int(sqrt($LIM / 2));

my @P = (map { int } `primes 2 @{[int($LIM/(2*3*3))+1]}`);

my $MAX_POWER = int( log($LIM) / log(2) );
foreach my $first_power (1 .. $MAX_POWER)
{
    I:
    foreach my $i (keys@P)
    {
        my $p = pow($P[$i], $first_power);
        if ($p > $LIM)
        {
            last I;
        }
        foreach my $second_power ($first_power + 1 .. $MAX_POWER)
        {
            J:
            foreach my $j ($i+1 .. $#P)
            {
                my $p2 = pow($P[$j], $second_power);
                my $t = $p * $p2;
                if ($t > $LIM)
                {
                    last J;
                }
                my $rec;
                $rec = sub {
                    my ($k, $p) = @_;
                    my $g = $P[$k];
                    if ($k == @P or $p * $g > $LIM)
                    {
                        return;
                    }
                    # say "b=$b";
                    $rec->($k+1, $p);
                    if (($k == $i) or ($k == $j))
                    {
                        return;
                    }
                    while ($p <= $LIM)
                    {
                        $p *= $g;
                        if ($p <= $LIM)
                        {
                            say $p;
                            $rec->($k+1,$p);
                        }
                    }
                    return;
                };
                say $t;
                $rec->(0, $t);
                undef($rec);
            }
        }
    }
}
