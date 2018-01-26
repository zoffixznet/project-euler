#!/usr/bin/perl

use strict;
use warnings;

use integer;

my $LIM = 200_000;

my $BASE = 5;
my @c5_counts = ( (0) x ( $LIM + 1 ) );

{
    my $base  = 1;
    my $power = $BASE;

    while ( $power <= $LIM )
    {
        for ( my $i = $power ; $i <= $LIM ; $i += $power )
        {
            $c5_counts[$i]++;
        }
    }
    continue
    {
        $base++;
        $power *= $BASE;
    }
}

my $result  = 0;
my $x_count = 0;
for my $x ( 0 .. $LIM )
{
    if ( $x % 1_000 == 0 )
    {
        print "X=$x\n";
    }
    my $y_count   = $x_count;
    my $LIM_min_x = $LIM - $x;
    for my $y ( 0 .. $LIM_min_x )
    {
        my $z = $LIM_min_x - $y;
        if ( ( $y_count += $c5_counts[$z] - $c5_counts[$y] ) >= 12 )
        {
            $result++;
        }

        # print $y_count, "\n";
    }

    $x_count += $c5_counts[ $LIM_min_x - 1 ] - $c5_counts[ $x + 1 ];
}
print "Result == $result\n";

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
