#!/usr/bin/perl

use strict;
use warnings;

use integer;

sub calc_A
{
    my ($n) = @_;

    my $mod = 1;
    my $len = 1;

    while ($mod)
    {
        $mod = ( ( $mod * 10 + 1 ) % $n );
        $len++;
    }

    return $len;
}

sub is_div
{
    my ($n) = @_;

    my $A = calc_A($n);

    while ( ( $A & 0x1 ) == 0 )
    {
        $A >>= 1;
    }

    while ( $A % 5 == 0 )
    {
        $A /= 5;
    }

    return ( $A == 1 );
}

open my $primes_fh, "(echo 3 ; primes 7 100000)|";

# 2 and 5 are such primes and calc_A() will get stuck for them.
my $sum = 2 + 5;

while ( my $line = <$primes_fh> )
{
    my $n = int($line);
    print "Checking $n\n";
    if ( !is_div($n) )
    {
        $sum += $n;
    }
}

close($primes_fh);

print "Sum = $sum\n";

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
