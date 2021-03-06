#!/usr/bin/perl

use strict;
use warnings;

my ($MAX_DIGIT) = @ARGV;

my $num_half_digits = $MAX_DIGIT + 1;
my $num_digits      = $num_half_digits * 2;

my $start = 10**( $num_digits - 1 );
my $end   = ( $MAX_DIGIT + 1 ) * $start - 1;

my $count = 0;

my $id = join( "", sort { $a cmp $b } ( ( 0 .. $MAX_DIGIT ) x 2 ) );

for my $n ( $start .. $end )
{
    if ( join( "", sort { $a cmp $b } split //, $n ) eq $id
        and ( $n % 11 == 0 ) )
    {
        print "Found $n\n";
        $count++;
    }
}

print "Count = $count\n";

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
