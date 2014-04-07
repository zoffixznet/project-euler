#!/usr/bin/perl

use strict;
use warnings;

use bytes;
use integer;
# use Math::GMP ();

use List::Util qw(first sum min);
use List::MoreUtils qw(none);

STDOUT->autoflush(1);

sub gcd
{
    my ($n, $m) = @_;

    if ($m > $n)
    {
        ($n, $m) = ($m, $n);
    }

    while ($m > 0)
    {
        ($n, $m) = ($m, $n%$m);
    }

    return $n;
}

sub lcm
{
    my ($n, $m) = @_;

    return ($n * $m / gcd($n,$m));
}

my $DEBUG = 0;

sub calc_P
{
    my ($MIN, $MAJ) = @_;

    my $total_count = 0;

    # For row == 1.
    $total_count += $MAJ;

    my %found;

    if ($DEBUG)
    {
        %found = (map { $_ => 1 } (1 .. $MAJ));
    }

    my @found_in_next;

    foreach my $row_idx (2 .. $MIN)
    {
        # print "row_idx == $row_idx\n";
        my $max = $row_idx * $MAJ;
        my $count = $MAJ;

        foreach my $prev_row (1 .. $row_idx-1)
        {
            my $prev_max = $prev_row * $MAJ;

            my $delta;
            if ($prev_row == 1)
            {
                $delta = int($prev_max / $row_idx);
            }
            else
            {
                $delta = ($found_in_next[$row_idx][$prev_row] // 0);
            }

            if ($DEBUG)
            {
                my @expected_delta =
                (grep { ($found{$_} // (-1)) == $prev_row } map { $_ * $row_idx } 1 .. $MAJ);

                if ($delta != @expected_delta)
                {
                    die "Row == $row_idx ; Prev_Row == $prev_row. There are $delta whereas there should be " . @expected_delta . " [@expected_delta]!\n";
                }
            }

            $count -= $delta;

            if ($count < 0)
            {
                die "Count is less than 0! (\$count=$count)\n";
            }
        }

        if ($DEBUG)
        {
            my @new = (grep { !exists($found{$_}) } map { $row_idx * $_ } 1 .. $MAJ);

            if (@new != $count)
            {
                die "Row == $row_idx. There are $count whereas there should be " . @new . "!\n";
            }

            %found = (%found, map { $_ => $row_idx } @new);
        }

        my $start_i = (($MAJ / $row_idx) + 1);
        my $start_i_prod = $start_i * $row_idx;

        foreach my $next_row ($row_idx+1 .. $MIN)
        {
            my $step = lcm($row_idx, $next_row);
            my $start_prod = ($start_i_prod / $step) * $step;
            if ($start_i_prod % $step)
            {
                $start_prod += $step;
            }
            my $prod = $start_prod;

            my @lcms;
            $lcms[$row_idx] = $step;

            for my $maj_factor (reverse(2 .. $row_idx-1))
            {
                $lcms[$maj_factor] = lcm(
                    $lcms[$maj_factor+1],
                    $maj_factor
                );
            }
            # print "LCMs[2] == ", $lcms[2], "\n";

            my $prev_maj_checkpoint = 0;
            MAJ_FACTOR:
            for my $maj_factor (2 .. $row_idx)
            {
                # my $maj_checkpoint = min($MAJ * $maj_factor, $end_prod);
                my $maj_checkpoint = $MAJ * $maj_factor;

                if ($prev_maj_checkpoint > 0)
                {
                    while ($prod <= $prev_maj_checkpoint)
                    {
                        $prod += $step;
                    }
                }
                $prev_maj_checkpoint = $maj_checkpoint;

                if ($prod > $maj_checkpoint)
                {
                    next MAJ_FACTOR;
                }

                my @prev_rows = ($maj_factor .. $row_idx-1);
                my $prev_rows_and_step_lcm = $lcms[$maj_factor];

                my $lookup_vec = '';

                my $prev_rows_div_step = $prev_rows_and_step_lcm / $step;

                if (0) # ($prev_rows_div_step == 1)
                {
                    vec($lookup_vec, 0, 1) = 1;
                }

                print "prev_rows_and_step_lcm == $prev_rows_and_step_lcm\n";

                foreach my $prev_row (@prev_rows)
                {
                    my $l = lcm($prev_row, $step);
                    for (my $i = 0; $i < $prev_rows_and_step_lcm ; $i += $l)
                    {
                        vec($lookup_vec, $i, 1) = 1;
                    }
                }

                my @counts = (0);
                {
                    my $step_i = 0;
                    for my $i (0 .. $prev_rows_div_step - 1)
                    {
                        push @counts, ($counts[-1] + (vec($lookup_vec, $step_i, 1) == 0));
                    }
                    continue
                    {
                        $step_i += $step;
                    }
                }
                # push @counts, $counts[-1];
                #

                my $_calc_num_mods_loop = sub {
                    my ($s, $e) = @_;

                    my $count = 0;
                    for my $i ($s .. $e)
                    {
                        if (vec($lookup_vec, $i*$step, 1) == 0)
                        {
                            $count++;
                        }
                    }

                    return $count;
                };

                my $_calc_num_mods = sub {
                    my ($s, $e) = @_;

                    return $counts[$e+1]-$counts[$s];
                };

                my $maj_end_prod_div = $maj_checkpoint / $step;
                my $maj_start_prod_div = $prod / $step;

                my $maj_end_prod_bound_lcm = ($maj_end_prod_div / $prev_rows_div_step) * $prev_rows_div_step;
                my $maj_start_prod_bound_lcm = ($maj_start_prod_div / $prev_rows_div_step) * $prev_rows_div_step;

                if ($maj_start_prod_div % $prev_rows_div_step)
                {
                    $maj_start_prod_bound_lcm += $prev_rows_div_step;
                }

                my $dump_all = sub {
                    print <<"EOF";
maj_start_prod_bound_lcm == $maj_start_prod_bound_lcm
maj_start_prod_div == $maj_start_prod_div
maj_end_prod_bound_lcm == $maj_end_prod_bound_lcm
maj_end_prod_div == $maj_end_prod_div
prod == $prod
maj_checkpoint == $maj_checkpoint
prev_rows_div_step == $prev_rows_div_step
prev_rows_and_step_lcm == $prev_rows_and_step_lcm
step == $step

EOF
                };

                my $cond1 = ($maj_end_prod_bound_lcm <= $maj_start_prod_bound_lcm);
                my $cond2 = ($maj_start_prod_bound_lcm >= $maj_end_prod_div);
                my $cond3 = ($maj_end_prod_bound_lcm <= $maj_start_prod_div);

                my @mini_deltas =
                (
                    [
                        $cond1,
                        sub {
                            return
                            (
                                (
                                    ($maj_end_prod_bound_lcm - $maj_start_prod_bound_lcm)
                                    / $prev_rows_div_step
                                )
                                * $_calc_num_mods->(0, $prev_rows_div_step - 1)
                            );
                        },
                    ],
                    [
                        $cond2,
                        sub {
                            return
                            $_calc_num_mods->(0, $maj_end_prod_div - $maj_end_prod_bound_lcm);
                        },
                    ],
                    [
                        $cond3,
                        sub {
                            return
                            (($maj_start_prod_bound_lcm > $maj_start_prod_div)
                                ? $_calc_num_mods->((($prev_rows_div_step + $maj_start_prod_div - $maj_start_prod_bound_lcm)), $prev_rows_div_step - 1)
                                : 0);
                        },
                    ],
                    [
                        scalar(not ($cond1 && $cond2 && $cond3)),
                        sub {
                            return
                            $_calc_num_mods->($maj_start_prod_div % $prev_rows_div_step, $maj_end_prod_div % $prev_rows_div_step);
                        },
                    ],
                );

                my $found_in_next_delta = 0;
                foreach my $mini (@mini_deltas)
                {
                    if (not $mini->[0])
                    {
                        $found_in_next_delta += ($mini->[2] = $mini->[1]->());
                    }
                }

                if (0 && $DEBUG)
                {
                    my @expected = grep {
                        my $prod = $_;
                        (none { $prod % $_ == 0 } $maj_factor .. $row_idx-1)
                    }
                    map { $prod + $_ * $step }
                    0 .. (($maj_checkpoint-$prod) / $step)
                    ;

                    if ($found_in_next_delta != @expected)
                    {
                        die "[FOO] Row == $next_row ; Prev_Row == $row_idx. There are $found_in_next_delta whereas there should be " . @expected . " [@expected]!\n";
                    }
                }
                ($found_in_next[$next_row][$row_idx] //= 0) += $found_in_next_delta;

                $prod = $maj_end_prod_div * $step;

=begin removed2

                while ($prod <= $maj_checkpoint)
                {
                    if (
                        ! vec($lookup_vec, $prod % $prev_rows_and_step_lcm, 1)
                        # none { $prod % $_ == 0 } @prev_rows
                    )
                    {
                        $found_in_next[$next_row][$row_idx]++;
                    }
                }
                continue
                {
                    $prod += $step;
                }
=end removed2

=cut

            }
            print "Row == $row_idx ; Next_row == $next_row\n";
        }

        $total_count += $count;
    }

    return $total_count;
}

sub my_test
{
    my ($MIN, $MAJ, $expected) = @_;

    my $got = calc_P($MIN, $MAJ);

    print "P($MIN, $MAJ) = $got (should be $expected)\n";

    if ($got != $expected)
    {
        die "Got is not expected.";
    }
}

if (1)
{
}

if (1)
{
my_test(4, 1000, 2416);
my_test(4, 4, 9);
my_test(3, 4, 8);
my_test(4, 7, 19);
my_test(4, 8, 20);
my_test(4, 9, 22);
my_test(4, 10, 24);
my_test(10, 10, 42);
my_test(11, 11, 53);
my_test(12, 12, 59);
my_test(12, 25, 143);
my_test(12, 345, 1998);
my_test(13, 13, 72);
my_test(14, 14, 80);
my_test(15, 20, 137);
my_test(16, 20, 142);
my_test(17, 20, 146);
my_test(18, 100, 824);
}

if (1)
{
my_test(64, 64, 1263);
}

if (0 and !$DEBUG)
{
my_test(32, (('1'.('0'x15))+0), 13826382602124302);
}
