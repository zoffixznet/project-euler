#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(min sum);
use List::MoreUtils qw();

use IO::All qw/io/;

STDOUT->autoflush(1);

my @factorials = (1);
for my $n ( 1 .. 9 )
{
    push @factorials, $factorials[-1] * $n;
}

my $SEEK = 150;
my $sum  = 0;

foreach my $l ( io()->file('./out.txt')->getlines() )
{
    if ( my ($digits) = $l =~ /\AFound g\([0-9]+\) == ([0-9]+) \(f=/ )
    {
        $sum += sum( split //, $digits );
    }
}

for my $n ( 68 .. $SEEK )
{
    my $anti_g = int( ( ( $n % 9 ) || '' ) . '9' x int( $n / 9 ) );

    my $x = 0 + $anti_g;
    for my $d ( reverse( 1 .. 9 ) )
    {
        $sum += $d * int( $x / $factorials[$d] );
        $x %= $factorials[$d];
    }
}
print "Sum == $sum\n";

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
