#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt 'lib' => 'GMP', ':constant';

use List::Util qw(sum);

my $bottom_power_nums = [];

for ( my $top_n = 2 ; ; $top_n++ )
{
    foreach my $base ( 2 .. $top_n )
    {
        my $power_num = $base**$top_n;

        if ( sum( split //, $power_num . q{} ) == $base )
        {
            push @$bottom_power_nums, $power_num;
        }
    }

    foreach my $exp ( 2 .. $top_n )
    {
        my $power_num = $top_n**$exp;

        if ( sum( split //, $power_num . q{} ) == $top_n )
        {
            push @$bottom_power_nums, $power_num;
        }
    }

    # Trim the list if needed.
    my @new = sort { $a <=> $b } @$bottom_power_nums;
    splice( @new, 30 );
    $bottom_power_nums = \@new;

    # Write the debugging stuff.
    print "Reached $top_n\n";
    foreach my $i ( 0 .. $#$bottom_power_nums )
    {
        print "PowerNum[", $i + 1, "] = ", $bottom_power_nums->[$i], "\n";
    }
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
