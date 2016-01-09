#!/usr/bin/perl

use strict;
use warnings;

use Math::BigRat lib => 'GMP';

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
