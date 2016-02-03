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

has 'sig' => (is => 'lazy');

sub _build_sig
{
    return pack_(shift->data);
}

sub place_in
{
    my ($class, $hash, $data, $records) = @_;

    my $obj = $class->new({ data => $data, records => $records});
    my $sig = $obj->sig;
    if (exists($hash->{$sig}))
    {
        return $hash->{$sig}->records;
    }
    else
    {
        $hash->{$sig} = $obj;
        return $obj->records;
    }
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

    foreach my $f (@fcc)
    {
        @$f = (sort {$a <=> $b } map { $_, $_+4 } @$f);
    }

    my $h1 = $one_wide_components{$type};
    my $h2 = DataObj->place_in($h1, $squares, +{});
    my $h3 = DataObj->place_in($h2, $squares, +{});
    my $count = DataObj->place_in($h3, (\@fcc), Math::BigInt->new('0'));
    $count++;

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

    my $sum = $left_l + $right_l;
    my $sum_mid = $mid{$sum} = {};

    $iter3->($mid{$left_l}, sub {
            my ($left_l_obj, $left_r_obj, $left_fcc_obj) = @_;
            $iter3->($mid{$right_l}, sub {
                    my ($right_l_obj, $right_r_obj, $right_fcc_obj) = @_;

                    my %fcc;

                    foreach my $f (@{$left_fcc_obj->data})
                    {
                        for my $i (0 .. $#$f)
                        {
                            for my $j (0 .. $#$f)
                            {
                                $fcc{"l$i"}{"l$j"} = 1;
                            }
                        }
                    }
                    foreach my $f (@{$right_fcc_obj->data})
                    {
                        for my $i (0 .. $#$f)
                        {
                            for my $j (0 .. $#$f)
                            {
                                $fcc{"r$i"}{"r$j"} = 1;
                            }
                        }
                    }
                    {
                        my $l = $left_r_obj->data;
                        my $r = $right_l_obj->data;

                        for my $i (0 .. 3)
                        {
                            my $l_bool = any { $_ == $RIGHT } @{$l->[$i]};
                            my $r_bool = any { $_ == $LEFT } @{$r->[$i]};
                            if ($l_bool xor $r_bool)
                            {
                                return;
                            }
                            if ($l_bool)
                            {
                                my $l_k = 'l' . ($i+4);
                                my $r_k = 'r' . $i;
                                $fcc{$l_k}{$r_k} = $fcc{$r_k}{$l_k} = 1;
                            }
                        }
                    }

                    my @nodes = (map {; "l$_", "r$_" } 0 .. 7);
                    my %found = (map { $_ => +{ $_ => 1 } } @nodes);

                    FIND:
                    while (1)
                    {
                        my $changed = 0;
                        foreach my $node (@nodes)
                        {
                            my %node_fcc = %{$found{$node}};
                            my $init_count = scalar keys %node_fcc;
                            foreach my $link (keys(%{$fcc{$node}}))
                            {
                                %node_fcc = (%node_fcc, %{$found{$link}});
                            }
                            if (scalar keys %node_fcc > $init_count)
                            {
                                $changed = 1;
                                foreach my $link (keys(%node_fcc))
                                {
                                    $found{$link} = {%node_fcc};
                                }
                            }
                        }
                        if (! $changed)
                        {
                            last FIND;
                        }
                    }

                    my @ret_fcc;
                    my @ret_nodes = qw(l0 l1 l2 l3 r4 r5 r6 r7);
                    my %ret_nodes_lookup = (map { $ret_nodes[$_] => $_ } keys @ret_nodes);
                    foreach my $node (@ret_nodes)
                    {
                        if (exists($found{$node}))
                        {
                            my @links = keys(%{$found{$node}});
                            push @ret_fcc, [sort { $a <=> $b } @ret_nodes_lookup{grep { exists($ret_nodes_lookup{$_}) } @links}];

                            foreach my $link (@links)
                            {
                                delete($found{$link});
                            }
                        }
                    }
                    if (scalar keys %found)
                    {
                        return;
                    }
                    my $h1 = $sum_mid;
                    my $h2 = DataObj->place_in($h1, $left_l_obj->data, +{});
                    my $h3 = DataObj->place_in($h2, $right_r_obj->data, +{});
                    my $count = DataObj->place_in($h3, (\@ret_fcc), Math::BigInt->new('0'));
                    $count += $left_fcc_obj->records * $right_fcc_obj->records;
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
