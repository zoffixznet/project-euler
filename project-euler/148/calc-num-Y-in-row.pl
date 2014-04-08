#!/usr/bin/perl

use strict;
use warnings;

use 5.016;

use integer;
# use Math::BigInt lib => 'GMP', ':constant';

my $BASE = 7;

my @D;

sub calc_num_Y_in_row_n
{
    my $recurse = sub {
        my ($d_len) = @_;

        if ($d_len <= 0)
        {
            return 0;
        }
        else
        {
            my $big_Y_total = ($D[$d_len]->{power}-1-$D[$d_len-1]->{total_mod}) * $D[$d_len]->{d};

            return $big_Y_total + ($D[$d_len]->{d}+1) * __SUB__->($d_len-1);
        }
    };

    return $recurse->($#D);
}

my $sum = 0;

push @D, {d => 1, power => 1, total_mod => 1};
for my $n (1 .. 999_999_999)
{
    $sum += calc_num_Y_in_row_n();

    if ($n % 10_000 == 0)
    {
        print "Reached $n [Sum == $sum]\n";
    }
}
continue
{
    my $l = 0;
    while ($l < @D && $D[$l]{d} == $BASE-1)
    {
        $D[$l]{d} = 0;
        $D[$l]{total_mod} = 0;
    }
    continue
    {
        $l++;
    }

    if ($l == @D)
    {
        my $power = $D[-1]{power}*$BASE;
        push @D, {d => 1,
            power => $power,
            total_mod => $D[-1]{total_mod} + $power,
        };
    }
    else
    {
        $D[$l]{d}++;
        foreach my $digit (@D[$l..$#D])
        {
            $digit->{total_mod}++;
        }
    }
}

# foreach my $n (@ARGV)
# {
#     print "${n}: ", calc_num_Y_in_row_n($n+1), "\n";
# }
print "Final Sum == $sum\n";
