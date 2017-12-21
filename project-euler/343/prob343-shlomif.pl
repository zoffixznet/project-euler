use strict;
use warnings;
use integer;

use feature qw/ say /;
use List::Util qw/ max /;

sub factor
{
    my ($n) = @_;
    my $r;
    my $f;
    while ( ( $n & 1 ) == 0 )
    {
        $f = 1;
        $n >>= 1;
    }
    if ($f)
    {
        $r = 2;
    }
    my $l = int sqrt $n;
    my $d = 3;
    while ( $d <= $l )
    {
        $f = 0;
        while ( $n % $d == 0 )
        {
            $n /= $d;
            $f = 1;
        }
        if ($f)
        {
            $r = $d;
            $l = int sqrt $n;
        }
        $d += 2;
    }
    return $n > 1 ? $n : $r;
}

my $s = 1;

# for 2 .. 20_000 -> Int $k {
for my $k ( 2 .. 2_000_000 )
{
    $s += max map { factor($_) } $k + 1, ( $k * $k - $k + 1 );
    say "$k : $s" if $k % 1_000 == 0;
}
say "Result = $s";

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
