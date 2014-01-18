#!/usr/bin/perl

=head1 DESCRIPTION

A particular school offers cash rewards to children with good attendance and punctuality. If they are absent for three consecutive days or late on more than one occasion then they forfeit their prize.

During an n-day period a trinary string is formed for each child consisting of L's (late), O's (on time), and A's (absent).

Although there are eighty-one trinary strings for a 4-day period that can be formed, exactly forty-three strings would lead to a prize:

OOOO OOOA OOOL OOAO OOAA OOAL OOLO OOLA OAOO OAOA
OAOL OAAO OAAL OALO OALA OLOO OLOA OLAO OLAA AOOO
AOOA AOOL AOAO AOAA AOAL AOLO AOLA AAOO AAOA AAOL
AALO AALA ALOO ALOA ALAO ALAA LOOO LOOA LOAO LOAA
LAOO LAOA LAAO

How many "prize" strings exist over a 30-day period?

=cut

use strict;
use warnings;

use 5.014;

use integer;
use bytes;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

sub make_pair
{
    my ($A, $L) = @_;

    return "$A,$L";
}

sub parse_pair
{
    return split/,/,shift;
}

my @counts;
$counts[0] = { make_pair(0,0) => 1 };

sub step
{
    my ($n) = @_;

    my $next = ($counts[$n] //= +{});

    while (my ($pair, $count) = each(%{$counts[$n-1]}))
    {
        my $add = sub
        {
            my ($A, $L) = @_;

            $next->{make_pair($A,$L)} += $count;

            return;
        };

        my ($num_A, $num_L) = parse_pair($pair);

        # Handle O - On-time.
        $add->(0, $num_L);
        # Handle A - Absent.
        if ($num_A < 3-1)
        {
            $add->($num_A+1,$num_L);
        }
        # Handle L - Late.
        if ($num_L < 1)
        {
            $add->(0, $num_L+1);
        }
    }
    return;
}

sub calc_count
{
    my ($n) = @_;

    return sum(values(%{$counts[$n]}));
}

my $pivot = 4;
for my $n (1 .. $pivot)
{
    step($n);
}

say "Count[$pivot] = ", calc_count($pivot);


