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

1;
