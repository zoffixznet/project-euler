package Euler480;

use strict;
use warnings;

use integer;
use bytes;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(reduce sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $MAX_LEN = 15;

my $WORD = "thereisasyetinsufficientdataforameaningfulanswer";

my %MAP;

foreach my $l (split//,$WORD)
{
    $MAP{$l}++;
}

my @LETTERS = (map { [$_,$MAP{$_}] } sort keys %MAP);

my @WEIGHTS_PROTO = (reverse sort { $a <=> $b } map { $_->[1] } @LETTERS);

my @WEIGHTS;

{
    my $start_idx = 0;
    foreach my $i (1 .. $#WEIGHTS_PROTO)
    {
        if ($WEIGHTS_PROTO[$i] != $WEIGHTS_PROTO[$start_idx])
        {
            push @WEIGHTS, [$WEIGHTS_PROTO[$start_idx], $i - $start_idx];
            $start_idx = $i;
        }
    }
    push @WEIGHTS, [$WEIGHTS_PROTO[$start_idx], $#WEIGHTS_PROTO - $start_idx];
}

my @caches_by_len;

sub calc_num_words_with_letters
{
    my ($weights, $max_len) = @_;

    if ($max_len == 0)
    {
        return 1;
    }

    return $caches_by_len[$max_len]{join(',',
            map { ($_->[0]) x $_->[1] } @$weights
        )
    } //= do {
        my $ret = 1;  # For the zero length string.

        my @new_weights;
        for my $w_idx (keys (@$weights))
        {
            my ($w, $count) = @{ $weights->[$w_idx] };
            $ret += $count * calc_num_words_with_letters(
                [@new_weights,
                    (($count > 1) ? ([$w, $count-1]) : ()),
                    (($w_idx < $#$weights)
                        ? (($weights->[$w_idx+1]->[0] == $w-1)
                            ? ([$w-1, $weights->[$w_idx+1]->[1]+1])
                            : ([$w-1, 1], $weights->[$w_idx+1])
                        )
                        : ($w > 1 ? ([$w-1, 1]) : ())
                    ),
                    @{$weights}[$w_idx+2 .. $#$weights]
                ],
                $max_len - 1
            );
            push @new_weights, $weights->[$w_idx];
        }

        $ret;
    };
}

sub calc_W
{
    my ($i) = @_;

}
