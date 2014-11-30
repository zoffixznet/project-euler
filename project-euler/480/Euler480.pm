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

sub _weights_from_proto
{
    my $WEIGHTS_PROTO = shift;
    my @WEIGHTS;
    my $start_idx = 0;
    foreach my $i (1 .. $#$WEIGHTS_PROTO)
    {
        if ($WEIGHTS_PROTO->[$i] != $WEIGHTS_PROTO->[$start_idx])
        {
            push @WEIGHTS, [$WEIGHTS_PROTO->[$start_idx], $i - $start_idx];
            $start_idx = $i;
        }
    }
    push @WEIGHTS, [$WEIGHTS_PROTO->[$start_idx], @$WEIGHTS_PROTO - $start_idx];

    return \@WEIGHTS;
}

my @WEIGHTS_PROTO = (reverse sort { $a <=> $b } map { $_->[1] } @LETTERS);
my @WEIGHTS = @{_weights_from_proto(\@WEIGHTS_PROTO)};
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

sub calc_P
{
    my ($w) = @_;

    my $ret = 0;

    my @letters = split//,$w;
    my %new_weights = %MAP;
    foreach my $l_idx (keys @letters)
    {
        my $l = $letters[$l_idx];
        LETTERS:
        for my $prev_l (sort { $a cmp $b } keys(%new_weights))
        {
            if ($prev_l ge $l)
            {
                $ret++;
                last LETTERS;
            }
            my %n = %new_weights;
            if ((--$n{$prev_l}) == 0)
            {
                delete ($n{$prev_l});
            }
            my $delta = calc_num_words_with_letters(
                _weights_from_proto(
                    [ reverse sort { $a <=> $b } values(%n) ],
                ),
                $MAX_LEN - 1 - $l_idx
            );
            # print "l_idx=$l_idx ; delta=$delta ; prev_l=$prev_l\n";
            $ret += $delta;
        }
        if ((--$new_weights{$l}) == 0)
        {
            delete($new_weights{$l});
        }
    }

    return $ret;
}

1;
