#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(sum);
use List::MoreUtils qw(none);




sub gcd
{
    my ($n, $m) = @_;

    if ($m == 0)
    {
        return $n;
    }

    return gcd($m,$n % $m);
}

my $COUNT = 10;

sub rec
{
    my ($in, $out) = @_;

    if (length($in) == $COUNT)
    {
        # Do the magic.
        # TODO :
        print "Checking $in\n";
        foreach my $cut_off (1 .. length($in)-1)
        {
            my $n1 = substr($in, 0, $cut_off);
            my $n2 = substr($in, $cut_off);
            my @n_s = (sort { $a <=> $b } $n1,$n2);
            if (none { /\A0/ } @n_s)
            {
                my $gcd = gcd(reverse @n_s);

                for my $d (2 .. $gcd)
                {
                    if ($gcd % $d == 0)
                    {
                        if (join('',sort { $a cmp $b } map { split//,$_ }
                                ($d, map { $_ / $d } @n_s)) eq '0123456789')
                        {
                            print "Found «$in» : " . join(" + ", (map {"$d*".($_/$d) } @n_s)) . " \n";
                            exit(0);
                        }
                    }
                }
            }
        }
        return;
    }

    foreach my $place (keys@$out)
    {
        rec($in.$out->[$place], [ @$out[grep { $_ != $place } keys(@$out)] ]);
    }
}

rec('', [reverse (0 .. 9)]);
