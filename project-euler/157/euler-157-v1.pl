#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

for my $n (9)
{
    my $t_n = ( 10**$n );
    my $B   = 1;
    while (1)
    {
        if ( $B == 1 or ( not( ( $B & 0b1 ) && ( $B % 5 ) ) ) )
        {
        A_LOOP:
            for my $A ( 1 .. $B )
            {
                my $num   = ( $A + $B ) * $t_n;
                my $denom = $A * $B;
                if ( $num % $denom == 0 )
                {
                    print "Found 1/$A+1/$B = " . ( $num / $denom ) . "/$t_n\n";
                }
                elsif ( ( $denom << 1 ) > $num )
                {
                    last A_LOOP;
                }
            }
        }
    }
    continue
    {
        $B++;
    }
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
