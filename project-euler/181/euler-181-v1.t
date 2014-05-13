#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Test::More tests => 11;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(min sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $count = 0;

my %Cache;

sub rec
{
    my ($n, $left) = @_;

    # print "Checking [$n,$left]\n";

    if ($left == 0)
    {
        return 1;
    }
    elsif ($n == 1)
    {
        return 1;
    }
    else
    {
        return $Cache{"$n|$left"} //= do {
            my $ret = 0;

            if ($left >= $n)
            {
                $ret += rec($n, $left-$n);
            }
            $ret += rec($n-1, $left);
            $ret;
        };
    }

}

my @C;

sub r_bw_helper
{
    my ($max_b_to_take, $count_of_b, $w_to_take, $count_of_w) = @_;

    my @args = map { @$_ }
            sort { $a->[1] <=> $b->[1] or $a->[0] <=> $b->[0] }
                    [$max_b_to_take,$count_of_b] ,[$w_to_take,$count_of_w];

    my $ret = r_bw(@args);
    # print "r_bw(@args) == $ret\n";
    return $ret;
}

sub r_bw
{
    my ($max_b_to_take, $count_of_b, $temp_max_w_to_take, $count_of_w) = @_;

    my $r;

    if ($max_b_to_take == 0 and $count_of_b)
    {
        $r = 0;
    }
    elsif ($count_of_b == 0)
    {
        if ($count_of_w == 0)
        {
            $r = 1;
        }
        else
        {
            $r = rec($count_of_w, $count_of_w);
        }
    }
    else
    {
        $r = $C[$max_b_to_take][$count_of_b][$temp_max_w_to_take][$count_of_w] //= do {
            my $ret = 0;

            # for my $new_b_delta (reverse(0 .. min($count_of_b, $max_b_to_take)))
            for my $new_b_delta (0 .. min($count_of_b, $max_b_to_take))
            {
                my $max_w_delta = (($new_b_delta == $max_b_to_take) ? $temp_max_w_to_take : $count_of_w);
                # for my $w_delta (reverse(0 .. min($count_of_w, $max_w_delta)))
                for my $w_delta (0 .. min($count_of_w, $max_w_delta))
                {
                    $ret += r_bw(
                        $new_b_delta,
                        $count_of_b - $new_b_delta,
                        $w_delta,
                        $count_of_w - $w_delta,
                    );
                }
            }
            $ret;
        };
    }

    # print "r_bw(@_) = $r\n";

    return $r;
}

sub bw_total
{
    my ($count_of_b, $count_of_w) = @_;

    my $ret = 0;

    $ret += r_bw($count_of_b, $count_of_b, $count_of_w, $count_of_w);

    return $ret;
}

# TEST
is (rec(1, 5), 1, 'rec(1,5)');

# TEST
is (rec(2, 5), 3, 'rec(2,5)');

# TEST
is (rec(3, 3), 3, 'rec(3,3)');

# TEST
is (rec(3, 4),
    (
        1 # 3,1
        + 1 # 2,2
        + 1 # 2,1,1
        + 1 # 1,1,1,1
    )
    , 'rec(3,3)');

# TEST
is (rec(4, 4),
    (
        1 # 4
        + 1 # 3,1
        + 1 # 2,2
        + 1 # 2,1,1
        + 1 # 1,1,1,1
    )
    , 'rec(4,4)');

# TEST
is (bw_total(0,0),
    1,
    "bw_total(1,1) == 2",
);

# TEST
is (bw_total(0,1),
    1,
    "bw_total(0,1) == 1",
);

# TEST
is (bw_total(1,0),
    1,
    "bw_total(1,0) == 1",
);

# TEST
is (bw_total(1,1),
    2, # BW ; B,W
    "bw_total(1,1) == 2",
);

# TEST
is (bw_total(2,1),
    4, # BBW ; BB,W ; BW,B ; B,B,W
    "bw_total(2,1) == 4",
);

# TEST
is (bw_total(3,1), 7, "bw_total(3,1) - given precase.");

my $NUM_OBJS = 60;
# print "Found ", rec($NUM_OBJS,$NUM_OBJS), "\n";
# exit(0);
print "bw_total(60,40) = ", bw_total(60,40), "\n";
