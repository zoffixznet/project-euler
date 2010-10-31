#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(sum);

sub is_prime
{
    my $n = shift;
    return (length(scalar(`primes $n @{[$n+1]}`)) > 0);
}

# print is_prime(5), "\n";
# print is_prime(10), "\n";

my @S_10_d;
MAIN_D_LOOP:
foreach my $main_d (1 .. 9, 0)
{
    foreach my $other_digits (1 .. 9)
    {
        my $sum = 0;

        my $iter;

        $iter = sub {
            my ($count, $num_so_far) = @_;

            if ($count == 0)
            {
                $num_so_far .= ($main_d x (10 - length($num_so_far)));
                if ($main_d == 1)
                {
                    print "Checking $num_so_far\n";
                }
                if (is_prime($num_so_far))
                {
                    $sum += $num_so_far;
                }
                return;
            }
            else
            {
                my $start = length($num_so_far);
                my $end = 10-$count;

                for my $pos ($start .. $end)
                {
                    foreach my $d (0 .. 9)
                    {
                        if ($d == $main_d)
                        {
                            next;
                        }
                        $iter->(
                            $count-1,
                            $num_so_far
                                .  ($main_d x ($pos-length($num_so_far)))
                                . $d
                        );
                    }
                }
                return;
            }
        };

        if (1)
        {
            for my $first_digit (1 .. 9)
            {
                $iter->($other_digits - ($first_digit == $main_d), $first_digit);
            }
        }
        else
        {
            $iter->($other_digits, '');
        }


        if ($sum > 0)
        {
            print "Found $sum\n";
            push @S_10_d, $sum;
            next MAIN_D_LOOP;
        }
    }
}

print map { "$_\n" } @S_10_d;
print "Sum = ", (sum @S_10_d), "\n";
