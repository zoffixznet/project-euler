#!/usr/bin/perl

use strict;
use warnings 'FATAL' => 'all';

use integer;
use bytes;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw(any none indexes);

use Cpanel::JSON::XS;

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

my $coder = Cpanel::JSON::XS->new->canonical(1);

sub pack_
{
    return $coder->encode(shift);
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
    my $h1 = $one_wide_components{$type};
    if (!exists($h1->{$sq_sig}))
    {
        $h1->{$sq_sig} = +{
            expanded => $squares,
            records => +{},
        };
    }
    my $h2 = $h1->{$sq_sig}{records};

    if (!exists($h2->{$sq_sig}))
    {
        $h2->{$sq_sig} = +{
            expanded => $squares,
            records => +{},
        };
    }

    my $h3 = $h2->{$sq_sig}{records};

    my $fcc_sig = pack_(\@fcc);
    if (!exists($h3->{$fcc_sig}))
    {
        $h3->{$fcc_sig} = +{
            expanded => \@fcc,
            count => 0,
        };
    }

    $h3->{$fcc_sig}{count}++;

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
            my $rec = $h->{$k};

            $cb->($k, $rec->{expanded}, $rec);
        }
    };

    my $iter3 = sub {
        my ($h, $cb) = @_;

        $iter1->($h, sub {
                my ($l_sig, $l_exp, $l_rec) = @_;
                $iter1->($l_rec->{records},
                    sub {
                        my ($r_sig, $r_exp, $r_rec) = @_;
                        $iter1->(
                            $r_rec->{records},
                            sub {
                                my ($fcc_sig, $fcc_exp, $fcc_rec) = @_;
                                return $cb->(
                                    $l_sig, $l_exp,
                                    $r_sig, $r_exp,
                                    $fcc_sig, $fcc_exp,
                                    $fcc_rec->{count}
                                );
                            }
                        );
                    }
                );
            }
        );
    };

    $iter3->($mid{$left_l}, sub {
            my (
                $left_l_sig, $left_l_exp,
                $left_r_sig, $left_r_exp,
                $left_fcc_sig, $left_fcc_exp,
                $left_count
            ) = @_;
            $iter3->($mid{$right_l}, sub {
                    my (
                        $right_l_sig, $right_l_exp,
                        $right_r_sig, $right_r_exp,
                        $right_fcc_sig, $right_fcc_exp,
                        $right_count
                    ) = @_;

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
