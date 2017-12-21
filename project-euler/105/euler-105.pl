#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(sum);
use IO::All;

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

        return;
    };

    eval { $recurse->( 0, 0, 0, 0, 0 ); };

    return !$@;
}

my $total_sum = 0;
foreach my $l ( io("sets.txt")->chomp->getlines() )
{
    print "Processing $l\n";
    my @set = split( /,/, $l );
    if ( is_special_sum_set( \@set ) )
    {
        $total_sum += sum(@set);
    }
}
print "Total Sum = $total_sum\n";

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
