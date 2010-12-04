#!/usr/bin/perl

use strict;
use warnings;

use integer;

use List::MoreUtils qw(uniq);
use List::Util qw(min);

=head1 DESCRIPTION

The most naive way of computing n15 requires fourteen multiplications:

n × n × ... × n = n15

But using a "binary" method you can compute it in six multiplications:

n × n = n2
n2 × n2 = n4
n4 × n4 = n8
n8 × n4 = n12
n12 × n2 = n14
n14 × n = n15

However it is yet possible to compute it in only five multiplications:

n × n = n2
n2 × n = n3
n3 × n3 = n6
n6 × n6 = n12
n12 × n3 = n15

We shall define m(k) to be the minimum number of multiplications to compute nk;
for example m(15) = 5.

For 1 ≤ k ≤ 200, find ∑ m(k).

=cut

my $comb1 = '';
vec($comb1, 1, 1) = 1;

my @combinations = (undef, [$comb1]);

sub is_superset
{
    my ($super, $sub, $true_superset) = @_;

    foreach my $key (keys(%$sub))
    {
        if (!exists($super->{$key}))
        {
            return;
        }
    }

    return ((!$true_superset) || (keys(%$super) > keys(%$sub)));
}

my $sum = 0;
print "1: 0\n";

foreach my $n (2 .. 200)
{
    # print "Reached $n\n";
    my $sets = [];

    foreach my $lower (1 .. ($n>>1))
    {
        my $upper = $n - $lower;

        push @$sets, (
            map { my $s = $_; vec($s, $n, 1) = 1; $s }
            grep { vec($_, $lower, 1) }
            @{$combinations[$upper]}
        );

=begin foo
        U_SET:
        foreach my $u_set (@{$combinations[$upper]})
        {
            if (!exists($u_set->{$lower}))
            {
                next U_SET;
            }

            my %new_set_hash = %$u_set;
            $new_set_hash{$n} = 1;

            CALC_NEW_SETS:
            {
                my @new_sets;

                SUPERSETS:
                foreach my $exist_idx (0 .. $#$sets)
                {
                    my $s = $sets->[$exist_idx];
                    if (is_superset($s, (\%new_set_hash), 1))
                    {
                        next SUPERSETS;
                    }
                    # If the new set is a superset of an existing set,
                    # then we don't want it here. Put all the existing sets in 
                    # place and skip this loop.
                    elsif (is_superset((\%new_set_hash), $s, 0))
                    {
                        last CALC_NEW_SETS;
                    }
                    else
                    {
                        push @new_sets, $s;
                    }
                }

                push @new_sets, (\%new_set_hash);
                $sets = \@new_sets;
            }
        }
=end foo

=cut

    }

    # $combinations[$n] = [sort { $a cmp $b } keys(%sets)];
    $combinations[$n] = $sets;

    my $result = -1 + min
    (
        map { unpack("b*", $_) =~ tr/1/1/ } @{$combinations[$n]}
    );

    print "${n}: $result\n";

    $sum += $result;
}

print "Sum = $sum\n";

