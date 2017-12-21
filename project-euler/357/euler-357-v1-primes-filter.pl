#!/usr/bin/perl

use strict;
use warnings;
use autodie;

use integer;
use bytes;

use List::MoreUtils qw/all/;

my $v = '';
open my $p_fh, '<', 'primes.txt';
while ( my $p = <$p_fh> )
{
    chomp($p);
    vec( $v, $p, 1 ) = 1;
}
close($p_fh);

# We've skipped those.
my $sum = 1 + 2;

open my $fh, '<', 'exprs.txt';
while ( my $l = <$fh> )
{
    chomp($l);
    my ( $n, @d ) = split / /, $l;
    if ( all { vec( $v, $_, 1 ) } @d )
    {
        # print "Adding $n\n";
        $sum += $n;
    }
    else
    {
        # print "Skipping $n\n";
    }
}
close($fh);
print "Sum = $sum\n";

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
