#!/usr/bin/perl

use strict;
use warnings;

use Math::BigRat lib => 'GMP';

my @c;
my %found;

my $FIRST = Math::BigRat->new('1/1');
$found{ $FIRST . '' } = undef;

# Last was an addition
my $ADD = 0;

# Last was a hyper
my $HYPER = 1;
$c[1] = [$FIRST];

sub print_cb
{
    my $d = shift;
    print "Reached Depth $d : Got " . scalar( keys(%found) ) . "\n";
}

print_cb(1);

for my $d ( 2 .. 18 )
{
    my $new = $c[$d] = [];
    for my $first ( 1 .. ( $d >> 1 ) )
    {
        my $second = $d - $first;
        for my $f ( @{ $c[$first] } )
        {
            for my $s ( @{ $c[$second] } )
            {
                foreach my $result ( ( $f + $s ), ( 1 / ( 1 / $f + 1 / $s ) ) )
                {
                    my $result_s = $result . '';
                    if ( !exists( $found{$result_s} ) )
                    {
                        $found{$result_s} = '';
                        push @$new, $result;
                    }
                }
            }
        }
    }
    print_cb($d);
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
