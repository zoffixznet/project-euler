#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt lib => 'GMP', ':constant';

# Let's assume, without loss of generality, that the leading (= most
# significant) of the number is "1". Then we just tr/1A/A1/ and multiply by two.

# Factorial
sub fact
{
    my $i = shift;
    return Math::BigInt->new($i)->bfac;
}

my $total_sum = 0;
for my $extra_len ((3-1) .. (16-1))
{
    print "extra_len == $extra_len\n";
    {
        my $sum = 0;
        for my $extra_num_1 (0 .. $extra_len-2)
        {
            my $num_A_0_others = $extra_len-$extra_num_1;
            for my $num_A (1 .. $num_A_0_others-1)
            {
                my $num_0_and_others = $num_A_0_others - $num_A;
                for my $num_0 (1 .. $num_0_and_others)
                {
                    my $num_others = $num_0_and_others - $num_0;
                    $sum +=
                    (
                        (
                            fact($extra_len) / ( fact($extra_num_1) * fact($num_A) * fact($num_0) * fact($num_others))
                        )
                        * ((16-3) ** $num_others)
                    );
                }
            }
        }
        print "Intermediate sum == $sum\n";
        $total_sum += $sum * 2;
    }
    {
        my $sum = 0;
        # Now for a leading digit that is neither 1 nor A (nor 0 obviously).
        for my $extra_num_others (0 .. $extra_len-3)
        {
            my $num_A_0_1 = $extra_len - $extra_num_others;
            my $num_others = $extra_num_others+1;
            for my $num_A (1 .. $num_A_0_1 - 2)
            {
                my $num_0_1 = $num_A_0_1 - $num_A;
                for my $num_1 (1 .. $num_0_1 - 1)
                {
                    my $num_0 = $num_0_1 - $num_1;
                    $sum +=
                    (
                        fact($extra_len) /
                        (
                            fact($extra_num_others)
                                *
                            fact($num_A)
                                *
                            fact($num_1)
                                *
                            fact($num_0)
                        )
                    ) * ((16-3) ** $num_others)
                }
            }
        }
        print "Intermediate sum{2} == $sum\n";
        $total_sum += $sum;
    }
}

print "Sum == $total_sum \nAs Hex: ",
    (uc($total_sum->as_hex =~ s/\A0x//r)), "\n";
