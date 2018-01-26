#!/usr/bin/perl

use strict;
use warnings;

use Math::GMP qw(:constant);

sub count
{
    my ( $min_tile_len, $max_tile_len, $total_len ) = @_;

    my @counts;

    foreach my $len ( 0 .. $min_tile_len - 1 )
    {
        push @counts, 1;
    }

    for my $len ( $min_tile_len .. $total_len )
    {
        my $sum = 0;

        foreach my $delta ( 1, ( $min_tile_len .. $max_tile_len ) )
        {
            if ( $delta <= @counts )
            {
                $sum += $counts[ -$delta ];
            }
        }
        push @counts, $sum;
    }

    # We need to exclude the all-black-squares one which is:
    # 1. Common.
    # 2. Should not be included.
    return $counts[-1];
}

print count( 2, 4, 50 ), "\n";

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
