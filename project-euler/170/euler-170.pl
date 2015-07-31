#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(sum);
use List::MoreUtils qw(none);


=head1 DESCRIPTION

Take the number 6 and multiply it by each of 1273 and 9854:

6 × 1273 = 7638 6 × 9854 = 59124

By concatenating these products we get the 1 to 9 pandigital 763859124. We will
call 763859124 the "concatenated product of 6 and (1273,9854)". Notice too,
that the concatenation of the input numbers, 612739854, is also 1 to 9
pandigital.

The same can be done for 0 to 9 pandigital numbers.

What is the largest 0 to 9 pandigital 10-digit concatenated product of an
integer with two or more other integers, such that the concatenation of the
input numbers is also a 0 to 9 pandigital 10-digit number?

=cut

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
