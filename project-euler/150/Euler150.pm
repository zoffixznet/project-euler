package Euler150::S;

use strict;
use warnings;

use integer;

my $t = 0;

sub get
{
    $t = ( ( 615949 * $t + 797807 ) & ( ( 1 << 20 ) - 1 ) );
    return ( $t - ( 1 << 19 ) );
}

package Euler150;

use strict;
use warnings;

use integer;

use List::Util qw(min);

sub solve
{
    my @sums = ();
    my $min  = 0;

    foreach my $row_idx ( 0 .. ( 1_000 - 1 ) )
    {
        print "Checking row $row_idx\n";
        my $row_sum = 0;
        my @row     = ($row_sum);
        foreach my $i ( 0 .. $row_idx )
        {
            push @row, ( $row_sum += Euler150::S::get() );
        }

        my $tri_idx = 0;
        foreach my $r ( 0 .. $row_idx )
        {
            foreach my $col ( 0 .. $r )
            {
                $min = min(
                    $min,
                    (
                        $sums[$tri_idx] +=
                            $row[ $col + $row_idx - $r + 1 ] - $row[$col]
                    )
                );
                $tri_idx++;
            }
        }
        print "Min = $min\n";
    }
}

1;

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
