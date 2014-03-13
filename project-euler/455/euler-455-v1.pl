#!/usr/bin/perl

use strict;
use warnings;

use 5.016;

use integer;
use bytes;

=head1 DESCRIPTION

Let f(n) be the largest positive integer x less than 109 such that the last 9 digits of nx form the number x (including leading zeros), or zero if no such integer exists.

For example:

    f(4) = 411728896 (4411728896 = ...490411728896)
    f(10) = 0
    f(157) = 743757 (157743757 = ...567000743757)
    Σf(n), 2 ≤ n ≤ 103 = 442530011399

Find Σf(n), 2 ≤ n ≤ 106.

=cut

my $MOD = 1_000_000_000;

sub func
{
    my ($n) = @_;

    my $e = 1;
    my $m = $n;

    my $found_e;

    while (($e < $MOD) && ($m != 1))
    {
        print "E=$e M=$m\n";
        if ($m == 0)
        {
            return 0;
        }
        elsif ($m == $n)
        {
            $found_e = $e;
        }
    }
    continue
    {
        $e++;
        $m = (($m * $n) % $MOD);
    }

    if ($e == $MOD or (!defined($found_e)))
    {
        return 0;
    }
    else
    {
        my $div = ($MOD / $e);
        my $mod = ($MOD % $e);

        return (($div - ($mod > $found_e)) *$e + $found_e);
    }
}

say "f(4) == ", func(4);
