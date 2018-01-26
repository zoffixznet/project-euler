#!/usr/bin/perl

use strict;
use warnings;

use Math::BigRat;

my $num_turns = shift(@ARGV);

my @B_nums_probs = (1);

foreach my $turn_idx ( 1 .. $num_turns )
{
    my $this_B_prob = Math::BigRat->new( '1/' . ( $turn_idx + 1 ) );

    push @B_nums_probs, (0);

    my @new_B_probs = map {
        my $i = $_;
        $B_nums_probs[$i] * ( 1 - $this_B_prob ) +
            ( ( $i == 0 ) ? 0 : ( $B_nums_probs[ $i - 1 ] * $this_B_prob ) )
    } ( 0 .. $turn_idx );

    @B_nums_probs = @new_B_probs;
}

my $s = Math::BigRat->new('0');

foreach my $idx ( int( $num_turns / 2 ) + 1 .. $num_turns )
{
    $s += $B_nums_probs[$idx];
}

print "S = $s\n";
print "Int[1/S] = ", int( 1 / $s ), "\n";

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
