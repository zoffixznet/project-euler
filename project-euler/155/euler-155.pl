#!/usr/bin/perl

use strict;
use warnings;

use Math::BigRat lib => 'GMP';

=begin explation.

An electric circuit uses exclusively identical capacitors of the same value C.
The capacitors can be connected in series or in parallel to form sub-units, which can then be connected in series or in parallel with other capacitors or other sub-units to form larger sub-units, and so on up to a final circuit.

Using this simple procedure and up to n identical capacitors, we can make circuits having a range of different total capacitances. For example, using up to n=3 capacitors of 60 F each, we can obtain the following 7 distinct total capacitance values:

If we denote by D(n) the number of distinct total capacitance values we can obtain when using up to n equal-valued capacitors and the simple procedure described above, we have: D(1)=1, D(2)=3, D(3)=7 ...

Find D(18).

Reminder : When connecting capacitors C1, C2 etc in parallel, the total capacitance is CT = C1 + C2 +...,
whereas when connecting them in series, the overall capacitance is given by:

=end
=cut

my @c;
my %found;

my $FIRST = '1/1';
$found{$FIRST} = undef;

# Last was an addition
my $ADD = 0;
# Last was a hyper
my $HYPER = 1;
$c[1][$ADD] = $c[1][$HYPER] = [$FIRST];

sub print_cb
{
    my $d = shift;
    print "Reached Depth $d : Got " . scalar(keys(%found)). "\n";
}

print_cb(1);

for my $d (2 .. 18)
{
    my $d_minus = $d-1;
    my @to_add_total;
    foreach my $op_rec
    (
        { idx => $ADD, op => sub { return $_[0] + $_[1]; }, },
        { idx => $HYPER, op => sub { return (1/(1/$_[0]+1/$_[1])); },}
    )
    {
        my $idx = $op_rec->{idx};
        my $op = $op_rec->{op};
        my $other_idx = (($idx == $ADD) ? $HYPER : $ADD);
        my %to_add;

        my $check_key = sub
        {
            my ($s) = @_;

            if ((! exists($found{$s})) and (! exists($to_add{$s})))
            {
                $to_add{$s} = undef();
                push @{$c[$d][$idx]}, $s;
            }

            return;
        };

        foreach my $key (@{$c[$d_minus][$idx]})
        {
            my $result = $op->(Math::BigRat->new($key),1);
            $check_key->($result.'');
        }

        for my $first (1 .. ($d>>1))
        {
            my $second = $d-$first;
            for my $f_key (@{$c[$first][$other_idx]})
            {
                my $f = Math::BigRat->new($f_key);
                for my $s_key (@{$c[$second][$other_idx]})
                {
                    my $s = Math::BigRat->new($s_key);

                    $check_key->($op->($f, $s).'');
                }
            }
        }
        push @to_add_total, \%to_add;
    }
    %found = (%found, map {%$_} @to_add_total);
    print_cb($d);
}
