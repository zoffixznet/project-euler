package Euler215;

use strict;
use warnings;

use integer;
use bytes;

use List::Util qw(sum);
use List::MoreUtils qw();

use parent 'Exporter';

our @EXPORT_OK = (qw(to_id from_id));

STDOUT->autoflush(1);

sub to_id
{
    my ($wall) = @_;

    my $v = '';
    while (my ($i, $rec) = each(@$wall))
    {
        vec($v, $i, 8) = (($rec->{o} & 0x1) | ($rec->{l} << 1));
    }

    return $v;
}

sub from_id
{
    my ($id) = @_;

    return [
        map { my $v = vec($id, $_, 8);
            +{ o => (2 | ($v&0x1)), l => ($v >> 1) }
        } 0 .. length($id)-1
    ];
}

our $LEN;
our $NUM_LAYERS;
our @levels;

sub solve_for_level
{
    # The level index.
    my ($l) = @_;

    while (my ($id, $count) = each(%{$levels[$l]}))
    {
        my $wall = from_id($id);

        my $min_i;
        my $min_len = $LEN+1;

        while (my ($i, $rec) = each @$wall)
        {
            my $len = $rec->{l};
            if ($len < $min_len)
            {
                $min_len = $len;
                $min_i = $i;
            }
        }

        my $rem = $LEN-$min_len;
        NEW:
        for my $new (($rem >= 5) ? (2,3) : ($rem == 3) ? (3) : (2))
        {
            my $new_len = $min_len+$new;
            if ($new_len != $LEN)
            {
                foreach my $i (
                    (($min_i > 0) ? ($min_i - 1) : ()),
                    (($min_i+1 < $NUM_LAYERS) ? ($min_i+1) : ()),
                )
                {
                    my ($o, $l) = @{$wall->[$i]}{qw(o l)};
                    if ($l == $new_len or ($l-$o) == $new_len)
                    {
                        next NEW;
                    }
                }
            }
            my $new_id = $id;
            vec($new_id, $min_i, 8) = (($new & 0x1) | ($new_len << 1));
            $levels[$new_len]{$new_id} += $count;
        }
    }

    # Free no longer necessary results.
    $levels[$l] = undef();

    return;
}

1;
