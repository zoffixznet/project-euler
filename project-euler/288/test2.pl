use strict;
use warnings;

use lib '.';

use Euler288 qw(factorial_factor_exp);
use Math::BigInt lib => "GMP", ":constant";

sub f
{
    return factorial_factor_exp( shift(), 61 ) % 61**10;
}

for my $x ( 1 .. 30 )
{
    my $xe = 61**$x;
    for my $y ( 1 .. 30 )
    {
        for my $f ( 1 .. 60 )
        {
            my $ye = $f * 61**$y;
            print "$x $y $f ", f( $xe + $ye ), " ",
                ( ( f($xe) + f($ye) ) % ( 61**10 ) ), "\n";
        }
    }
}

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
