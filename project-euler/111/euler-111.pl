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

my $count_digits = 10;
my @digits = (0 .. 9);
my @non_zero_digits = (1 .. 9);

my @S_10_d;
MAIN_D_LOOP:
foreach my $main_d (@digits)
{
    foreach my $num_other_digits (1 .. $count_digits-1)
    {
        my $sum = 0;
        my $N_d = 0;

        my $iter;

        $iter = sub {
            my ($count, $num_so_far) = @_;

            if ($count == 0)
            {
                $num_so_far .= ($main_d x ($count_digits - length($num_so_far)));
                # print "Checking $num_so_far\n";
                if (is_prime($num_so_far))
                {
                    # print "Added $num_so_far\n";
                    $sum += $num_so_far;
                    $N_d++;
                }
                return;
            }
            else
            {
                my $start = length($num_so_far);
                my $end = $count_digits-$count;

                for my $pos ($start .. $end)
                {
                    OTHER_DIGIT_LOOP:
                    foreach my $d (@digits)
                    {
                        if ($d == $main_d)
                        {
                            next OTHER_DIGIT_LOOP;
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
            for my $first_digit (@non_zero_digits)
            {
                $iter->($num_other_digits - ($first_digit != $main_d), $first_digit);
            }
        }
        else
        {
            $iter->($num_other_digits, '');
        }


        if ($sum > 0)
        {
            print "M_$main_d = ", $count_digits - $num_other_digits, "\n";
            print "N_$main_d = $N_d\n";
            print "S_$main_d = $sum\n";
            push @S_10_d, $sum;
            next MAIN_D_LOOP;
        }
    }
}

print map { "$_\n" } @S_10_d;
print "Sum = ", (sum @S_10_d), "\n";
