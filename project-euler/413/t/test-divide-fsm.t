#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 170000;

use DivideFsm;

for my $BASE ( grep { $_ != 10 } 2 .. 19 )
{
    my ( $g, $r ) = DivideFsm::get_div_fsms($BASE);

    # for my $i (1 .. 10000)
    for my $i ( () )
    {
        my @d = reverse split //, $i;

        my $s = 0;
        for my $digit (@d)
        {
            $s = $r->[$s]->[$digit];
        }

        #+TEST*10000*17
        is( ( $s == 0 ) ? 1 : 0, ( $i % $BASE == 0 ) ? 1 : 0, "Num matches" );
    }

    for my $i ( 1 .. 10000 )
    {
        my @d = split //, $i;

        my $s = 0;
        for my $digit (@d)
        {
            $s = $g->[$s]->[$digit];
        }

        # TEST*10000*17
        is( ( $s == 0 ) ? 1 : 0, ( $i % $BASE == 0 ) ? 1 : 0, "Num matches" );
    }
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
