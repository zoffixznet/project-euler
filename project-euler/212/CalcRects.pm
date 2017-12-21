package CalcRects;

use strict;
use warnings;

use integer;
use bytes;

use Rand;

sub calc_rects
{
    my $r = Rand->new;

    my @rects;

    for my $n ( 1 .. 50_000 )
    {
        my @myrect;

        for my $i ( 1 .. 3 )
        {
            push @myrect, $r->get() % 10_000;
        }
        for my $i ( 1 .. 3 )
        {
            push @myrect, ( 1 + ( $r->get() % 399 ) );
        }

        push @rects, \@myrect;
    }

    return \@rects;
}

sub calc_processed_rects
{
    return [
        map {
            my $r = $_;
            [ map { [ $r->[$_], $r->[$_] + $r->[ 3 + $_ ] - 1 ] } 0 .. 2 ]
        } @{ calc_rects() }
    ];
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
