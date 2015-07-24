#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

package Nexter;

sub new
{
    my ($class, $args) = @_;
    return bless $args, shift;
}

sub next
{
    my $self = shift;

    my $skip_all_zeros = $self->[2];

    my $ret;

    do
    {
        $ret = sprintf("%0" . $self->[0] . 'd', ($self->[1]++));

        if ($self->[1] == 10 ** $self->[0])
        {
            $self->[0]++;
            $self->[1] = 0;
        }
    } while($skip_all_zeros && $ret !~ /[1-9]/);

    return $ret;
}

package main;

sub test_nexter
{
    my ($num_digits, $base, $ret1, $ret2) = @_;

    my $obj = Nexter->new([$num_digits, $base]);

    if ($obj->next ne $ret1)
    {
        die "Nexter ret1: @_";
    }
    if ($obj->next ne $ret2)
    {
        die "Nexter ret2: @_";
    }

    return;
}

test_nexter(1,9, '9', '00');
test_nexter(1,0, '0', '1');
test_nexter(2, 0, '00', '01');
test_nexter(2, 99, '99', '000');

my ($n, $MAX_COUNT) = @ARGV;

my $next_mins = 1;
my @mins = ({ s => '', strs => {next => Nexter->new([0,0,0]), s => '',}});

my @s_pos = (grep { substr($n, $_, 1) ne '0' } (1 .. length($n) -1));
my %mm = (map { $_ => +{ next => Nexter->new([0,0,0]), s => '' } } @s_pos);

{
    my @c = (undef(), 1);

    sub start_10
    {
        my $l = shift;
        return $c[$l] //= do {
            ($l-1) * (9 * 10 ** ($l-2)) + start_10($l-1);
        };
    }
}

sub calc_start
{
    my $needle = shift;

    my $len = length($needle);

    return start_10($len) + ($needle - (10 ** ($len-1))) * $len;
}

sub test_calc_start
{
    my ($needle, $want_pos) = @_;

    my $have_pos = calc_start($needle);
    if ($have_pos != $want_pos)
    {
        die "For needle=$needle got $have_pos instead of $want_pos";
    }
}

test_calc_start(1, 1);
test_calc_start(2, 2);
test_calc_start(10, 10);
test_calc_start(11, 12);
test_calc_start(99, 10+(99-10)*2);
test_calc_start(100, 10+(100-10)*2);
test_calc_start(200, 10+(100-10)*2+(200-100)*3);
test_calc_start(1000, 10+(100-10)*2+(1000-100)*3);

my @seq_poses;

{
    my %p;
    my $len = length($n);
    for my $item_l (1 .. $len)
    {
        START_POS:
        for my $start_pos (0 .. $item_l-1)
        {
            if (substr($n, $start_pos, 1) eq '0')
            {
                next START_POS;
            }
            my $s = my $init_s = substr($n, $start_pos, $item_l);
            if ($start_pos > 0)
            {
                my $prev = $s-1;
                if (substr($n, 0, $start_pos) ne substr($prev, -$start_pos))
                {
                    next START_POS;
                }
            }
            my $pos = $start_pos + length($s);
            my $next_s = $s + 1;
            while ($pos <= $len - length($s))
            {
                if (substr($n, $pos, length($next_s)) eq $next_s)
                {
                    $pos += length($next_s);
                    $s = $next_s++;
                }
                else
                {
                    next START_POS;
                }
            }

            if ($pos < $len)
            {
                if (substr($s+1, 0, $len-$pos) ne substr($n,$pos))
                {
                    next START_POS;
                }
            }
            # Let's rock and roll.
            $p{calc_start($init_s) - $start_pos} = 1;
        }
    }

    @seq_poses = sort {$a <=> $b } keys(%p);
}

my $last_pos = 0;
my $count = 1;

my $count_9s = 1;

my $is_count_9s;
my $c9_pos;

my $count_9s_base;

if (($count_9s_base) = ($n =~ /\A9+(.0*)\z/))
{
    $is_count_9s = 1;
}

while ($count <= $MAX_COUNT)
{
    my $min;
    # For within a number containing the full number:

    my $last_i;
    my $which = '';

    if (@seq_poses)
    {
        if (!defined($min) or $seq_poses[0] < $min)
        {
            $min = $seq_poses[0];
            $which = "seq_poses";
        }
    }
    while (my ($i, $rec) = each@mins)
    {
        my $r = $rec->{strs};
        my $pos = $r->{p} //= do {

            my $prefix = $rec->{'s'};
            my $suffix = $r->{'s'};

            my $needle = $prefix.$n.$suffix;

            calc_start($needle) + length($prefix);
        };
        if (!defined($min) || $pos < $min)
        {
            $last_i = $i;
            $min = $pos;
            $which = 'contained';
        }
    }
    if (defined($last_i) && ($last_i == $#mins))
    {
        push @mins, +{ s => ($next_mins++), strs => {next => Nexter->new([0,0,0]), s => ''} };
    }

    my $last_s;
    for my $start_new_pos (@s_pos)
    {
        my $rec = $mm{$start_new_pos};

        my $pos = $rec->{p} //= sub {
            my $prefix = substr($n, $start_new_pos);
            my $middle = $rec->{'s'};
            my $suffix = substr($n, 0, $start_new_pos);

            my $needle = $prefix.$middle.$suffix;
            my $offset = length($prefix)+length($middle);
            if ($needle =~ /\A.?9+\z/)
            {
                my $d = (substr($needle, 0, -1) - 1);
                if ($d < 0)
                {
                    return -1;
                }
                else
                {
                    $needle = ($d . '9');
                    $offset = length($d);
                }
            }
            return calc_start($needle) + $offset;
        }->();

        if (!defined($min) || $pos < $min)
        {
            $last_s = $start_new_pos;
            $which = 'mid';
            $min = $pos;
        }
    }

    if ($is_count_9s)
    {
        COUNT9:
        while (!defined $c9_pos)
        {
            my $c9 = $count_9s_base . '0' x $count_9s;
            my $c9_minus_1 = $c9 - 1;
            my $both = $c9_minus_1 . $c9;
            if ($both =~ /\Q$n\E/g)
            {
                my $offset = pos($both) - length($n);
                my $pos = calc_start($c9_minus_1) + $offset;

                $c9_pos = $pos;
                last COUNT9;
            }
        }
        continue
        {
            $count_9s++;
        }
        if (!defined($min) || $c9_pos < $min)
        {
            $min = $c9_pos;
            $which = 'c9';
        }
    }

    if ($which eq 'seq_poses')
    {
        shift(@seq_poses);
    }
    elsif ($which eq 'c9')
    {
        $c9_pos = undef;
        $count_9s++;
    }
    else
    {
        my $rec;
        if ($which eq 'mid')
        {
            $rec = $mm{$last_s};
        }
        else
        {
            $rec = $mins[$last_i]{'strs'};
        }
        $rec->{'s'} = $rec->{'next'}->next;
        $rec->{'p'} = undef;
    }

    if ($min > $last_pos)
    {
        print "$min\n";
        $count++;
        $last_pos = $min;
    }
}
