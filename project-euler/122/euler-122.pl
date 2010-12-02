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

my @combinations = (undef, [{}]);

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
foreach my $n (2 .. 200)
{
    print "Reached $n\n";
    my $sets = [];

    foreach my $lower (1 .. ($n>>1))
    {
        my $upper = $n - $lower;
        
        foreach my $l_set (@{$combinations[$lower]})
        {
            foreach my $u_set (@{$combinations[$upper]})
            {
                my @new_s = uniq(sort { $a <=> $b } (keys(%$l_set), keys(%$u_set), $n));

                my %new_set_hash = (map { $_ => 1 } @new_s);

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
                            push @new_sets, $s
                        }
                    }

                    push @new_sets, (\%new_set_hash);
                    $sets = \@new_sets;
                }
            }
        }
    }

    # $combinations[$n] = [sort { $a cmp $b } keys(%sets)];
    $combinations[$n] = $sets;

    my $result = min (map { scalar( keys(%$_)) } @{$combinations[$n]});

    print "Found $result\n";

    $sum += $result;
}

print "Sum = $sum\n";

