#!/usr/bin/perl

use strict;
use warnings 'FATAL' => 'all';

use integer;
use bytes;

use Math::BigInt lib => 'GMP'; #, ':constant';

package DataObj;

use Cpanel::JSON::XS;
my $coder = Cpanel::JSON::XS->new->canonical(1);

sub pack_
{
    return $coder->encode(shift);
}

use MooX qw/late/;

# The data.
has 'data' => (is => 'ro', required => 1);
# The values.
has 'records' => (is => 'rw', required => 1);

sub sig
{
    return pack_(shift->data);
}

package main;

use List::Util qw(sum);
use List::MoreUtils qw(any none indexes);


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

    my $sq_obj = DataObj->new({ data => $squares, records => {}});
    my $h1 = $one_wide_components{$type};
    if (!exists($h1->{$sq_obj->sig}))
    {
        $h1->{$sq_obj->sig} = $sq_obj;
    }
    $sq_obj = DataObj->new({ data => $squares, records => {}});
    my $h2 = $h1->{$sq_obj->sig}{records};

    if (!exists($h2->{$sq_obj->sig}))
    {
        $h2->{$sq_obj->sig} = $sq_obj;
    }

    my $h3 = $h2->{$sq_obj->sig}{records};

    my $fcc_obj = DataObj->new({ data => (\@fcc), records => Math::BigInt->new('0')});
    if (!exists($h3->{$fcc_obj->sig}))
    {
        $h3->{$fcc_obj->sig} = $fcc_obj;
    }

    $h3->{$fcc_obj->sig}{records}++;

    return;
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

use Data::Dumper;

print Dumper(\%one_wide_components);

my %mid;

sub merge_middle
{
    my ($left_l, $right_l) = @_;

    my $iter1 = sub {
        my ($h , $cb) = @_;

        foreach my $k (keys%$h)
        {
            my $obj = $h->{$k};

            $cb->($obj);
        }
    };

    my $iter3 = sub {
        my ($h, $cb) = @_;

        $iter1->($h, sub {
                my ($l_obj) = @_;
                $iter1->($l_obj->records,
                    sub {
                        my ($r_obj) = @_;
                        $iter1->(
                            $r_obj->records,
                            sub {
                                my ($fcc_obj) = @_;
                                return $cb->(
                                    $l_obj,
                                    $r_obj,
                                    $fcc_obj,
                                );
                            }
                        );
                    }
                );
            }
        );
    };

    $iter3->($mid{$left_l}, sub {
            my ($left_l_obj, $left_r_obj, $left_fcc_obj) = @_;
            $iter3->($mid{$right_l}, sub {
                    my ($right_l_obj, $right_r_obj, $right_fcc_obj) = @_;
                }
            );
        }
    );
}

$mid{1} = $one_wide_components{middle};
# my $LEN = 10 ** 12;
my $LEN = 10;

# Subtract 1 for the left and 1 for the right.
my $MIDDLE_LEN = $LEN - 2;

{
    my $l = 1;
    my $next_l = $l << 1;
    while ($next_l <= $MIDDLE_LEN)
    {
        print "Calling merge_middle($l,$l) → $next_l\n";
        merge_middle($l, $l);
    }
    continue
    {
        $l = $next_l;
        $next_l <<= 1;
    }
}
