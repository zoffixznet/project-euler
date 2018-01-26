#!/usr/bin/perl

use strict;
use warnings;

my $pat = '1_2_3_4_5_6_7_8_9_0';

# If ($s * $s) % 10 == 0 then $s % 10 == 0 so $s *$s % 100 == 0
my $pat2 = '1_2_3_4_5_6_7_8_900';

# If ($s * $s) % 10 == 0 then $s % 10 == 0 so $s *$s % 100 == 0
my $pat3 = '1_2_3_4_5_6_7_8[048]900';

foreach my $d1 ( 0, 4, 8 )
{
    my $d_suffix = "8${d1}900";

    my $recurse;

    $recurse = sub {
        my ( $prefix, $l ) = @_;

        if ( $l == 8 )
        {
            my $n  = $prefix . $d_suffix;
            my $sq = int( sqrt($n) );
            if ( $sq * $sq == $n )
            {
                print "Result == $sq ; Square == $n\n";

                # exit(0);
            }
        }
        else
        {
            foreach my $d ( 0 .. 9 )
            {
                $recurse->( $prefix . $l . $d, $l + 1 );
            }
        }
        return;
    };

    $recurse->( '', 1 );
}

# die "Could not find.";

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
