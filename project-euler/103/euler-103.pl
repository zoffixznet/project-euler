#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(sum);

=head1 ANALYSIS

* If A is a special sum set then any subset S in A is also a special sum set.

* If A = (a1,a2...a7) in ascending order then:

* * a1+a2 > a7.

* * a1+a2+a3 > a6+a7

* * a1+a2+a3+a4 > a5+a6+a7

* 20, 20+11, 20+18, 20+19, 20+20,  20+22, 20+25 =
= 20, 31, 38, 39, 40, 42, 45 is a special sum set.

=cut

sub is_special_sum_set
{
    my $A = shift;

    my $recurse;

    $recurse = sub {
        my ( $i, $B_sum, $B_count, $C_sum, $C_count ) = @_;

        if ( $i == @$A )
        {
            if (
                   ( !$B_count )
                || ( !$C_count )
                || (   ( $B_sum != $C_sum )
                    && ( ( $B_count > $C_count ) ? ( $B_sum > $C_sum ) : 1 )
                    && ( ( $C_count > $B_count ) ? ( $C_sum > $B_sum ) : 1 ) )
                )
            {
                # Everything is OK.
                return;
            }
            else
            {
                die "Not a special subset sum.";
            }
        }

        $recurse->( $i + 1, $B_sum + $A->[$i], $B_count + 1, $C_sum, $C_count );
        $recurse->( $i + 1, $B_sum, $B_count, $C_sum + $A->[$i], $C_count + 1 );
        $recurse->( $i + 1, $B_sum, $B_count, $C_sum,            $C_count );
    };

    eval { $recurse->( 0, 0, 0, 0, 0 ); };

    return !$@;
}

print is_special_sum_set( [ 20, 31, 38, 39, 40, 42, 45 ] ), "\n";

# print is_special_sum_set([6, 9, 11, 12, 13]), "\n";
# print is_special_sum_set([1,2,3]), "\n";

my $min_sum = sum( 20, 31, 38, 39, 40, 42, 45 );

sub check_A
{
    my ($A_so_far) = @_;

    if ( !is_special_sum_set($A_so_far) )
    {
        return;
    }

    if ( @$A_so_far == 7 )
    {
        print "@$A_so_far\n";
        my $s = sum(@$A_so_far);
        if ( $s < $min_sum )
        {
            $min_sum = $s;
            print "min_sum = $min_sum\n";
            print "\@A = ", join( ",", @$A_so_far ), "[", @$A_so_far, "]\n";
        }

        return;
    }
    else
    {
        for my $next_item ( $A_so_far->[-1] + 1 .. 45 - ( 6 - @$A_so_far ) )
        {
            check_A( [ @$A_so_far, $next_item ] );
        }
        return;
    }
}

for my $a1 ( reverse( 1 .. 20 ) )
{
    print "A[0] = $a1\n";
    check_A( [$a1] );
}

=head1 COPYRIGHT & LICENSE

Copyright 2017 by Shlomi Fish

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
