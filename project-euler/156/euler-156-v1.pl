#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(sum);

my @s_n = (0);
my @f_n = (0);

STDOUT->autoflush(1);

for my $n ( 1 .. 1_000_000_000_000 )
{
    if ( $n % 1_000_000 == 0 )
    {
        print "Reached $n\n";
    }
    for my $d ( split //, $n )
    {
        $f_n[$d]++;
    }
    foreach my $d ( 1 .. 9 )
    {
        if ( $f_n[$d] == $n )
        {
            $s_n[$d] += $n;
        }
    }
}

print "\@s_n == [@s_n]\nSum == ", sum(@s_n), "\n";

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
