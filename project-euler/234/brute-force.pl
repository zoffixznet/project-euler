#!/usr/bin/perl

use strict;
use warnings;

use POSIX qw(ceil floor);

my %p = ( map { $_ => 1 } map { /(\d+)/ ? $1 : () } `primesieve -p1 2 1000` );
for my $n ( 4 .. 1000 )
{
    my $c = 0;
    {
        my $s = floor( sqrt($n) );
        while ( !exists( $p{$s} ) )
        {
            --$s;
        }
        if ( $n % $s == 0 )
        {
            ++$c;
        }
    }
    {
        my $s = ceil( sqrt($n) );
        while ( !exists( $p{$s} ) )
        {
            ++$s;
        }
        if ( $n % $s == 0 )
        {
            ++$c;
        }
    }
    if ( $c == 1 )
    {
        print "$n\n";
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
