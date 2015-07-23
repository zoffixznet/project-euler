#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $n = shift(@ARGV);

my %mins;

$mins{contained} =
{
    next => 1,
    strs => [{ s => '', strs => {next => 1, str => '',}},],
};

my %mm = (map { $_ => +{ next => 1, s => '' } } 1 .. length($n)-1);

sub start_10
{
    my $l = shift;
    if ($l == 1)
    {
        return 1;
    }
    else
    {
        return +($l-1) * (9 * 10 ** ($l-2)) + start_10($l-1);
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

my $last_pos;
my $count = 1;
while (1)
{
    my $min;
    # For within a number containing the full number:

    my $contained = $mins{contained}{strs};

    my $last_i;
    my $which = '';
    while (my ($i, $rec) = each@$contained)
    {
        my $prefix = $rec->{'s'};
        my $suffix = $rec->{strs}->{str};

        my $needle = $prefix.$n.$suffix;

        my $pos = calc_start($needle) + length($prefix);
        if (!defined($min) || $pos < $min)
        {
            $last_i = $i;
            $min = $pos;
            $which = 'contained';
        }
    }
    if ($last_i == $#$contained)
    {
        push @{ $mins{contained}{strs} }, +{ s => ($mins{contained}{'next'}++), strs => {next => 1, str => ''} };
    }

    my $last_s;
    for my $start_new_pos (1 .. length($n)-1)
    {
        my $prefix = substr($n, $start_new_pos);
        my $middle = $mm{$start_new_pos}{'s'};
        my $suffix = substr($n, 0, $start_new_pos);

        my $needle = $prefix.$middle.$suffix;

        my $pos = calc_start($needle) + length($prefix)+length($middle);

        if (!defined($min) || $pos < $min)
        {
            $last_s = $start_new_pos;
            $which = 'mid';
            $min = $pos;
        }
    }

    my $rec;
    if ($which eq 'mid')
    {
        $rec = $mm{$last_s};
    }
    else
    {
        $rec = $mins{contained}{strs}[$last_i];
    }
    $rec->{'s'} = $rec->{'next'}++;
    print $count++, " $min\n";
}
