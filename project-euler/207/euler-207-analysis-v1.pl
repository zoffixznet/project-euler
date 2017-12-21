#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $frac = shift(@ARGV) || '1/12345';

my ( $numer, $denom ) = split /\//, $frac;

my $n          = 3;
my $num_powers = 2;

sub cond
{
    return ( ( $num_powers - 1 ) * $denom < ( $n - 1 ) * $numer );

    # return (($num_powers-1) * 13 < ($n-1) * 3);
    # return (($num_powers-1) * 5 < ($n-1) * 2);
}

MAIN:
while (1)
{
    if ( cond() )
    {
        print "For \$num_powers=$num_powers ; \$n=$n\n";
        last MAIN;
    }
}
continue
{
    $n *= 2;
    $n++;
    $num_powers++;
}

while ( cond() )
{
    $n--;
}

$n++;

print "N = $n\n";
print "k = ", ( $n * $n - $n ), "\n";

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
