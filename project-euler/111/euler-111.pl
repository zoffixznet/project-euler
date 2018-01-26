#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(sum);

use List::MoreUtils qw(all);

sub is_prime1
{
    my $n = shift;
    return ( length( scalar(`primes $n @{[$n+1]}`) ) > 0 );
}

sub is_prime2
{
    my $n = shift;

    return all { $n % $_ } ( 2 .. int( sqrt($n) ) + 1 );
}

=begin verification

This function throws an exception due to a bug in bsd-games' primes.

sub is_prime
{
    my $n = shift;

    my $v1 = is_prime1($n);
    my $v2 = is_prime2($n);

    if ($v1 xor $v2)
    {
        die "Results don't match for $n!";
    }

    return $v1;
}

=end verification

=cut

*is_prime = \&is_prime2;

# print is_prime(5), "\n";
# print is_prime(10), "\n";

my $count_digits    = 10;
my @digits          = ( 0 .. 9 );
my @non_zero_digits = ( 1 .. 9 );

my @S_10_d;
MAIN_D_LOOP:
foreach my $main_d (@digits)
{
    foreach my $num_other_digits ( 1 .. $count_digits - 1 )
    {
        my $sum = 0;
        my $N_d = 0;

        my $iter;

        $iter = sub {
            my ( $count, $num_so_far ) = @_;

            if ( $count == 0 )
            {
                $num_so_far .=
                    ( $main_d x ( $count_digits - length($num_so_far) ) );

                # print "Checking $num_so_far\n";
                if ( is_prime($num_so_far) )
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
                my $end   = $count_digits - $count;

                for my $pos ( $start .. $end )
                {
                OTHER_DIGIT_LOOP:
                    foreach my $d (@digits)
                    {
                        if ( $d == $main_d )
                        {
                            next OTHER_DIGIT_LOOP;
                        }
                        $iter->(
                            $count - 1,
                            $num_so_far
                                . ( $main_d x ( $pos - length($num_so_far) ) )
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
                $iter->(
                    $num_other_digits - ( $first_digit != $main_d ),
                    $first_digit
                );
            }
        }
        else
        {
            $iter->( $num_other_digits, '' );
        }

        if ( $sum > 0 )
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
print "Sum = ", ( sum @S_10_d ), "\n";

=head1 COPYRIGHT & LICENSE

Copyright 2018 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

=cut
