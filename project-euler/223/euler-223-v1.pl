#!/usr/bin/perl

use strict;
use warnings;

# use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use feature qw/say/;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $LIM = 25_000_000;

# For the case where A = 1.
my $count = int( sqrt( ( $LIM - 1 ) / 2 ) );
my $As    = 4;
my $Ad    = 3;
my $l     = $LIM / 3;
A:
for my $A ( 2 .. $l )
{
    print "Checking A=$A\n";
    my $Cs = ( ( $As << 1 ) - 1 );
    my $Bd = $Ad;
    for my $B ( $A .. $l )
    {
        my $C = int( sqrt($Cs) );
        if ( $A + $B + $C > $LIM )
        {
            next A;
        }
        if ( $C * $C == $Cs )
        {
            say "Found ($A,$B,$C) @{[++$count]}";
        }
    }
    continue
    {
        $Cs += ( $Bd += 2 );
    }
}
continue
{
    $As += ( $Ad += 2 );
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
