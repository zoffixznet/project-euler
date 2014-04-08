#!/usr/bin/perl

use strict;
use warnings;

use bytes;
use integer;

use Config;

use Math::GMP ();

use List::Util qw(first sum min);
use List::MoreUtils qw(any none uniq);

STDOUT->autoflush(1);

sub gcd
{
    my ($n, $m) = @_;

    return Math::GMP->new($n)->bgcd($m);
}

sub lcm
{
    my ($n, $m) = @_;

    return Math::GMP->new($n)->blcm($m);
}

sub multi_lcm
{
    my ($n_s) = @_;

    my $lcm = 1;

    foreach my $n (@$n_s)
    {
        $lcm = lcm($lcm, $n);
    }

    return $lcm;
}

# Small gcd (sgcd) and small lcm (slcm) that don't involve Math::GMP.

sub sgcd
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

sub slcm
{
    my ($n, $m) = @_;

    return ($n * $m / sgcd($n,$m));
}

sub count_mods_up_to_LIM
{
    my ($_r, $step, $l) = @_;

    # Let's try to calculate in a smarter way.
    my $recurse;

    $recurse = sub {
        my ($depth, $rows, $lcm, $lims) = @_;

        if ($depth == @$_r)
        {
            my $sign = ($rows & 0x1 ? (-1) : 1);
            # Including the modulo at zero.
            foreach my $l (@$lims)
            {
                $l->[0] += $sign*(1 + $l->[1] / $lcm);
            }
        }
        else
        {
            # If the lcm is greater, than the rest
            # of the sum will be 0 because the lcm
            # will only get larger and $l->[1] / $lcm
            # would be always 0, so they will cancel
            # each other.
            my @new_lims = grep { $lcm <= $_->[1] } @$lims;

            if (@new_lims)
            {
                $recurse->(
                    $depth+1,
                    $rows,
                    $lcm,
                    \@new_lims,
                );
                $recurse->(
                    $depth+1,
                    $rows+1,
                    slcm($lcm, $_r->[$depth]),
                    \@new_lims,
                );
            }
        }

        return;
    };

    my @LIM = ( map { [0,$_*$step] } @$l );

    $recurse->(0, 0, $step, \@LIM);

    return [map { $_->[0] } @LIM];
}

my $DEBUG = 1;

use Inline (C => <<'EOF',

void calc_counts(SV * c_out_ref, AV * Q_proto, IV step, IV prev_rows_div_step, HV * C_hash, AV * P_proto)
{
    IV Q_len = (1+av_len(Q_proto));
    IV * Q = malloc(sizeof(Q[0]) * (Q_len+1));

    IV i;
    for (i = 0 ; i < Q_len ; i++)
    {
        SV ** sv = av_fetch(Q_proto, i, 0);
        Q[i] = SvIV(*sv);
    }
    Q[i] = 0;

    IV P_len = (1+av_len(P_proto));
    IV * P = malloc(sizeof(P[0]) * 2 * P_len);

    for (i = 0 ; i < P_len ; i++)
    {
        SV ** sv = av_fetch(P_proto, i, 0);
        AV * sv_av = (AV *)SvRV(*sv);
        P[(i << 1)] = SvIV(*(av_fetch(sv_av, 0, 0)));
        P[(i << 1)+1] = SvIV(*(av_fetch(sv_av, 1, 0)));
    }

    IV P_l = (P_len << 1);

    IV s = 0;

    IV c = 0;

    IV q_idx = 0;
    IV q = Q[q_idx++];

    IV j;
    for (j = 0, i = s * step; j <= prev_rows_div_step; (i += step), j++)
    {
        if (j == q)
        {
            SV * j_key = newSViv(j);
            SV * c_val = newSViv(c);

            char * j_str = SvPVbyte_nolen(j_key);

            hv_store(
                C_hash,
                j_str,
                strlen(j_str),
                c_val,
                0
            );

            SvREFCNT_dec(j_key);

            q = Q[q_idx++];
        }

        for (int x = 0; x < P_l ; x += 2)
        {
            IV d = P[x];
            IV m = P[x+1];
            while (m < i)
            {
                m += d;
            }
            if (i == (P[x+1] = m))
            {
                goto loop_end;
            }
        }
        c++;
        loop_end:
        ;
    }

    SV * c_out = SvRV(c_out_ref);
    sv_setiv(c_out, c);

    /* Cleanup. */
    free (Q);
    free (P);

    return;
}
EOF
    CLEAN_AFTER_BUILD => 0,
    CCFLAGS => ($Config{ccflags} . ' -std=gnu99'),
);

=begin hello

sub calc_counts
{
    my ($c_out_ref, $Q, $step, $prev_rows_div_step, $C, $P) = @_;

    my ($s, $e_p) = (0, $prev_rows_div_step);
    my $e = $e_p * $step;

    my $c = 0;

    my $q = shift(@$Q);

    I:
    for (my $j = 0, my $i = $s * $step; $i <= $e; ($i += $step), ($j++))
    {
        if ($j == $q)
        {
            $C->{$j} = $c;
            $q = shift(@$Q);
        }

        foreach my $x (@$P)
        {
            my ($d,$m) = @$x;
            while ($m < $i)
            {
                $m += $d;
            }
            if (($x->[1] = $m) == $i)
            {
                next I;
            }
        }
        $c++;
    }

    $$c_out_ref = $c;

    return;
}

=end hello

=cut

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
            my $step = slcm($row_idx, $next_row);
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
                print "Row == $row_idx ; Next_row == $next_row ; Maj_factor == $maj_factor\n";
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
                    print ("Skipped prod=$prod ; maj_checkpoint=$maj_checkpoint\n");
                    next MAJ_FACTOR;
                }

                my @prev_rows = ($maj_factor .. $row_idx-1);

                if (any { $step % $_ == 0 } @prev_rows)
                {
                    printf ("Skipped due to step evenly divisible for step=%d ; prev_rows=[%s]\n", $step, join(",",@prev_rows));
                }
                else
                {
                    my @aft_rows;

                    foreach my $row (@prev_rows)
                    {
                        if (none { $row % $_ == 0 } @aft_rows)
                        {
                            push @aft_rows, $row;
                        }
                    }

                    my $prev_rows_and_step_lcm = $lcms[$maj_factor];


                    my $prev_rows_div_step = $prev_rows_and_step_lcm / $step;


                    my $maj_end_prod_div = $maj_checkpoint / $step;
                    my $maj_start_prod_div = $prod / $step;

                    my $maj_end_prod_bound_lcm = ($maj_end_prod_div / $prev_rows_div_step) * $prev_rows_div_step;
                    my $maj_start_prod_bound_lcm = ($maj_start_prod_div / $prev_rows_div_step) * $prev_rows_div_step;

                    if (0)
                    {
                        my @_mods_checkpoints_base =
                        (
                            0,
                            $prev_rows_div_step - 1,
                            $maj_end_prod_div - $maj_end_prod_bound_lcm,
                            (($prev_rows_div_step + $maj_start_prod_div - $maj_start_prod_bound_lcm)),
                            $maj_start_prod_div % $prev_rows_div_step,
                            $maj_end_prod_div % $prev_rows_div_step
                        );
                        my %c;
                        my $c = 0;
                        my @Q = uniq(sort { $a <=> $b } map { $_, $_+1 } @_mods_checkpoints_base);
                        my @p = map { [(''.lcm($_,$step))+0,0] } @aft_rows;

                        print "Calculating for prev_rows_div_step=$prev_rows_div_step with repetition of lcm=" . multi_lcm([@aft_rows]) . " aft_rows=[@aft_rows]\n";
                        calc_counts(
                            \$c,
                            \@Q,
                            $step,
                            $prev_rows_div_step,
                            \%c,
                            \@p,
                        );
                    }

                    # my $LIM = $prev_rows_and_step_lcm;

                    # Returns the number of MODs from 0 up to its argument
                    # - inclusive. So $_count_mods_up_to_LIM->(0) can be
                    # non-zero.

                    my $_count_mods_up_to_LIM;

                    {
                        # Put the largest ones first.
                        my @_r = reverse@aft_rows;

                        $_count_mods_up_to_LIM  = sub {
                            return count_mods_up_to_LIM(\@_r, $step, shift);
                        };
                    }


                    # If $c is 0 then $_calc_num_mods will always return 0 so
                    # the delta will be 0.
                    if (0) # if (! $c)
                    {
                        my $c = 0;
                        printf ("Skipped for count=%d ; prev_rows_div_step=%d ; step=%d ; aft_rows=[%s]\n", $c, $prev_rows_div_step, $step, join(",",@aft_rows));
                    }
                    else
                    {
                        # checkpoints
                        # my %out_hash = (map { $_cp[$_] => $out_arr->[$_] } keys(@$out_arr));
                        # $out_hash{-1} = 0;
                        #
                        my %out_hash;

                        my $_calc_num_mods = sub {
                            my ($s, $e) = @_;

                            # my $ret = $c{$e+1}-$c{$s};
                            # my $ret = $_count_mods_up_to_LIM->($e)-$_count_mods_up_to_LIM->($s-1);
                            # my $ret = $_count_mods_up_to_LIM->($e)-(($s == 0) ? (-1) : $_count_mods_up_to_LIM->($s));

                            # my $ret = $_count_mods_up_to_LIM->($e)-(($s==0) ? 0 : $_count_mods_up_to_LIM->($s-1));
                            my $ret = $out_hash{$e}-$out_hash{$s-1};

                            printf ("_calc_num_mods: [%d->%d]/%d == %d\n", $s, $e, $prev_rows_div_step, $ret);

                            return $ret;
                        };

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

                        my $end_mod1 = $prev_rows_div_step - 1;
                        my $end_mod2 = $maj_end_prod_div - $maj_end_prod_bound_lcm;
                        my $start_mod3 = (($prev_rows_div_step + $maj_start_prod_div - $maj_start_prod_bound_lcm));
                        my $start_mod4 = $maj_start_prod_div % $prev_rows_div_step;
                        my $end_mod4 = $maj_end_prod_div % $prev_rows_div_step;

                        my $_end = sub {
                            return $_[0];
                        };

                        my $_start = sub {
                            return $_[0]-1;
                        };

                        my @mini_deltas =
                        (
                            [
                                $cond1,
                                [$_end->($end_mod1)],
                                sub {
                                    return
                                    (
                                        (
                                            ($maj_end_prod_bound_lcm - $maj_start_prod_bound_lcm)
                                            / $prev_rows_div_step
                                        )
                                        * $_calc_num_mods->(0, $end_mod1)
                                    );
                                },
                            ],
                            [
                                $cond2,
                                [$_end->($end_mod2)],
                                sub {
                                    return
                                    $_calc_num_mods->(0, $end_mod2);
                                },
                            ],
                            [
                                $cond3,
                                [$_start->($start_mod3), $_end->($end_mod1)],
                                sub {
                                    return
                                    (($maj_start_prod_bound_lcm > $maj_start_prod_div)
                                        ? $_calc_num_mods->($start_mod3, $end_mod1)
                                        : 0);
                                },
                            ],
                            [
                                scalar(not ($cond1 && $cond2 && $cond3)),
                                [$_start->($start_mod4),$_end->($end_mod4)],
                                sub {
                                    return
                                    $_calc_num_mods->($start_mod4, $end_mod4);
                                },
                            ],
                        );

                        my $found_in_next_delta = 0;
                        foreach my $mini (@mini_deltas)
                        {
                            if (not $mini->[0])
                            {
                                foreach my $mod (@{$mini->[1]})
                                {
                                    $out_hash{$mod} = undef;
                                }
                                $mini->[3] = $mini->[2];
                            }
                            else
                            {
                                $mini->[3] = sub { return 0; };
                            }
                        }
                        my @k = keys(%out_hash);
                        my $out_arr = $_count_mods_up_to_LIM->(
                            \@k
                        );

                        foreach my $i (keys@k)
                        {
                            $out_hash{$k[$i]} = $out_arr->[$i];
                        }
                        $out_hash{-1} = 0;

                        foreach my $mini (@mini_deltas)
                        {
                            $found_in_next_delta += ($mini->[4] = $mini->[3]->());
                        }

                        if (1 && $DEBUG)
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
                    }
                }

                $prod = (($maj_checkpoint / $step) * $step);
            }
            # print "Row == $row_idx ; Next_row == $next_row\n";
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

sub main
{
    if ($DEBUG)
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

    if (0 && $DEBUG)
    {
        my_test(64, 64, 1263);
    }

    if (0 and !$DEBUG)
    {
        my_test(32, (('1'.('0'x15))+0), 13826382602124302);
    }

    if (1 and !$DEBUG)
    {
        my $WRONG_RESULT = 100;
        my_test(64, (('1'.('0' x 16))+0), $WRONG_RESULT);
    }

}

$DEBUG = 1;
main();
$DEBUG = 0;
main();


__END__

=begin foo

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

=end foo

=cut
=begin foo

                    my $lookup_vec = '';

                    if (0) # ($prev_rows_div_step == 1)
                    {
                        vec($lookup_vec, 0, 1) = 1;
                    }

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

                    printf ("_calc_num_mods: [%d-%d]/%d\n", $s,$e,scalar(@counts));

                    return $counts[$e+1]-$counts[$s];
                };

=end foo

=cut

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
