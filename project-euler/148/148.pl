#!/usr/bin/perl

use strict;
use warnings;

my $prev_row_count = 1;
my $prev_row       = '';
my $next_row       = '';

my @mod = (
    map {
        my $y = $_;
        [ map { ( $y + $_ ) % 7 } ( 0 .. 6 ) ]
    } ( 0 .. 6 )
);

my $result_count = 0;

# while ($row_count++ <= 1_000_000_000)
vec( $prev_row, 0, 8 ) = 1;
$result_count++;
while ( $prev_row_count < 1_000_000_000 )
{
    if ( $prev_row_count % 1_000 == 0 )
    {
        print "Reached $prev_row_count\n";
    }
    vec( $next_row, 0, 8 ) = 1;
    for my $i ( 1 .. $prev_row_count - 1 )
    {
        if ( vec( $next_row, $i, 8 ) =
            $mod[ vec( $prev_row, $i - 1, 8 ) ][ vec( $prev_row, $i, 8 ) ] )
        {
            $result_count++;
        }
    }
    vec( $next_row, $prev_row_count, 8 ) = 1;

    # For the two 1s on the sides of the row.
    $result_count += 2;
}
continue
{
    $prev_row = $next_row;
    $next_row = '';
    $prev_row_count++;
}

print "Result count = $result_count\n";

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
