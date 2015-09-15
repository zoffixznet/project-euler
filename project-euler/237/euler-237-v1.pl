#!/usr/bin/perl

use strict;
use warnings 'FATAL' => 'all';

use integer;
use bytes;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw(any none);

STDOUT->autoflush(1);

my %one_wide_components =
(
    left => {},
    right => {},
    middle => {},
);

my $UP = 0;
my $RIGHT = 1;
my $DOWN = 2;
my $LEFT = 3;

sub pack_
{
    my ($sq) = @_;
    my $ret = eval q| join('#', map { sum(map { 1 << $_ } @$_) } @$sq);|;
    if ($@)
    {
        die $@;
    }
    return $ret;
}

sub insert
{
    my ($type, $squares) = @_;

    my @fcc;

    push @fcc, [0];
    for my $i (1 .. 3)
    {
        if (none { $_ == $UP } @{$squares->[$i]})
        {
            push @fcc, [];
        }
        push @{$fcc[-1]}, $i;
    }
    if (! @{$fcc[-1]})
    {
        pop(@fcc);
    }

    my $sq_sig = pack_($squares);
    $one_wide_components{$type}{$sq_sig}{$sq_sig}{pack_(\@fcc)}++;
}

sub piece_dirs
{
    my ($bef) = @_;

    if (@$bef == 4)
    {
        my @squares =  (map { [@$_] } @$bef);
        for my $i (0 .. 2)
        {
            if (any { $_ == $DOWN } @{$bef->[$i]})
            {
                if (none { $_ == $UP } @{$bef->[$i+1]})
                {
                    # Invalid piece.
                    return;
                }
            }
        }

        my $upper_up = (any { $_ == $UP } @{$bef->[0]});
        my $lower_down = (any { $_ == $DOWN } @{$bef->[-1]});
        if ($upper_up || $lower_down)
        {
            # Candidate for left.
            if ($upper_up && $lower_down)
            {
                # Candidate for left.
                $squares[0] = [ grep { $_ != $UP } @{$squares[0]}];
                $squares[-1] = [ grep { $_ != $DOWN } @{$squares[-1]}];
                if (any { any { $_ == $LEFT } @$_ } @squares)
                {
                    return;
                }
                insert('left', \@squares);
            }
            return;
        }

        if (none { any { $_ == $RIGHT } @$_ } @$bef)
        {
            # Candidate for right.
            insert('right', \@squares);

            return;
        }

        insert('middle', \@squares);
    }
    else
    {
        for my $low (0 .. 2)
        {
            for my $high ($low+1 .. 3)
            {
                piece_dirs([@$bef, [$low,$high]]);
            }
        }
    }

    return;
}

piece_dirs([]);
