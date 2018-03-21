#!/usr/bin/perl

use strict;
use warnings;

sub riffle
{
    my $in = shift;

    my $half = @$in >> 1;

    my @ret;
    foreach my $i ( 0 .. $half - 1 )
    {
        push @ret, @$in[ $i, $half + $i ];
    }
    return \@ret;
}

my $sum = 0;

sub multi
{
    my $n = shift;

    my $start = [ 0 .. $n - 1 ];
    my $WANT  = ( join ',', @$start );
    my $x     = riffle($start);
    my $i     = 1;
    while ( ( join ',', @$x ) ne $WANT )
    {
        # print map { "$_: $x->[$_]\n" } keys @$x;
        $x = riffle($x);
        if ( ++$i > 60 )
        {
            return;
        }
    }
    if ( $i == 60 )
    {
        $sum += $n;
        print "$i = $n ( $sum )\n";
    }
    return;
}

STDOUT->autoflush(1);
my $n = 0;
while (1)
{
    multi( $n += 2 );
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