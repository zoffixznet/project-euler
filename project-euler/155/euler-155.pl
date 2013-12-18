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

my $FIRST = Math::BigRat->new('1/1');
$found{$FIRST.''} = undef;

# Last was an addition
my $ADD = 0;
# Last was a hyper
my $HYPER = 1;
$c[1] = [$FIRST];

sub print_cb
{
    my $d = shift;
    print "Reached Depth $d : Got " . scalar(keys(%found)). "\n";
}

print_cb(1);

for my $d (2 .. 18)
{
    my $new = $c[$d] = [];
    for my $first (1 .. ($d>>1))
    {
        my $second = $d-$first;
        for my $f (@{$c[$first]})
        {
            for my $s (@{$c[$second]})
            {
                foreach my $result (($f+$s), (1/(1/$f+1/$s)))
                {
                    my $result_s = $result.'';
                    if (!exists($found{$result_s}))
                    {
                        $found{$result_s} = '';
                        push @$new, $result;
                    }
                }
            }
        }
    }
    print_cb($d);
}
