#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(reduce);
use Math::GMP;

my @factorials = (1);
while ($#factorials != 9)
{
    push @factorials, Math::GMP->new($factorials[-1] * @factorials);
}

# print join(",", @factorials), "\n";

my @num_chains;

my %cache = ();

sub find_for_n
{
    my ($n, $pos, $c) = @_;

    my $n_str = $n."";

    if (exists($c->{$n_str}))
    {
        # It's a loop.
        return [0, $c->{$n_str}];
    }
    elsif (exists($cache{$n_str}))
    {
        return [$cache{$n_str}, $pos];
    }
    else
    {
        my ($ret, $recurse_pos) =
            @{find_for_n(
                (reduce { $a + $b } @factorials[split//,$n_str]),
                $pos+1,
                { %{$c}, $n_str => $pos},
            )};

        if (!exists($cache{$n_str}))
        {
            $cache{$n_str} = $ret+1;
        }
        return [$ret+1, $pos];
    }
}

foreach my $n (1 .. 999_999)
{
    if ($n % 10_000 == 0)
    {
        print "N = $n \n";

        foreach my $i (0 .. $#num_chains)
        {
            if (defined($num_chains[$i]))
            {
                print "num_chains[$i] = $num_chains[$i]\n";
            }
        }
        print "N = $n \n";
    }

    # print "$n = " , $c{$i . ""} . "\n";
    $num_chains[find_for_n($n, 0, {})->[0]]++;
}

foreach my $i (0 .. $#num_chains)
{
    if (defined($num_chains[$i]))
    {
        print "num_chains[$i] = $num_chains[$i]\n";
    }
}

1;
