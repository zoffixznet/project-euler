#!/usr/bin/perl

use strict;
use warnings;

use 5.022;

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

my $SQ = int(sqrt($LIM / 2));

my @P = (map { int } `primes 2 $SQ`);

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
                    if (($k == $i) or ($k == $j))
                    {
                        return $rec->($k+1, $p);
                    }
                    while ($p < $LIM)
                    {
                        $p *= $P[$k];
                        if ($p < $LIM)
                        {
                            say $p;
                            $rec->($k+1,$p);
                        }
                    }
                };
                say $t;
                $rec->(0, $t);
                undef($rec);
            }
        }
    }
}
