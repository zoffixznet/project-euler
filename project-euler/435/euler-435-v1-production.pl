#!/usr/bin/perl

use strict;
use warnings;

use lib '.';
use Euler435 ();

{
    my $n   = Math::GMP->new( '1' . '0' x 15 );
    my $sum = 0;
    foreach my $x ( 1 .. 100 )
    {
        my $obj = Euler435->new(
            {
                calc_1_matrix => sub {
                    my $matrix1   = Euler435::gen_empty_matrix();
                    my $matrix1_t = Euler435::gen_empty_matrix();

                    my $assign = sub {
                        return Euler435::assign( $matrix1, $matrix1_t, @_ );
                    };

                    $assign->( 0, 0, 1 );
                    $assign->( 0, 1, 1 );
                    $assign->( 1, 2, 1 );
                    $assign->( 2, 1, $x * $x );
                    $assign->( 2, 2, $x );
                    return { normal => $matrix1, transpose => $matrix1_t, };

                }
            }
        );

        $sum += $obj->calc_count( $x, $n );
    }
    print "Result = ", $sum % $Euler435::MOD, "\n";
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
