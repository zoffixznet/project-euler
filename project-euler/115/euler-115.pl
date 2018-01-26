#!/usr/bin/perl

use strict;
use warnings;

use Math::GMP qw(:constant);

my @counts;

my $min_len = 50;

foreach my $len ( 0 .. $min_len - 1 )
{
    push @counts, { start_with_block => 0, start_with_square => 1 };
}

LEN_LOOP:
for my $len ( $min_len .. 1_000_000 )
{
    my $with_square =
        $counts[-1]->{start_with_block} + $counts[-1]->{start_with_square};
    my $with_block = 0;
    for my $block_len ( $min_len .. $len - 1 )
    {
        $with_block += $counts[ -$block_len ]->{start_with_square};
    }

    # For $block_len == $len
    $with_block++;
    push @counts,
        +{
        start_with_block  => $with_block,
        start_with_square => $with_square
        };

    if ( $with_block + $with_square > 1_000_000 )
    {
        print "Found $len\n";
        last LEN_LOOP;
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
