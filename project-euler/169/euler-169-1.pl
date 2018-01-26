#!/usr/bin/perl

use strict;
use warnings;

use 5.014;
use Math::BigInt lib => 'GMP', ':constant';

STDOUT->autoflush(1);

my %cache;

sub recurse
{
    my ( $n, $max_factor ) = @_;

    if ( $n == 0 )
    {
        return 1;
    }

    if ( $max_factor == 0 )
    {
        return 0;
    }

    if ( ( ( ( $max_factor << 1 ) - 1 ) << 1 ) < $n )
    {
        return 0;
    }

    my $ret = (
        $cache{"$n;$max_factor"} //=
            do
        {

            my $ret = 0;

        COUNT:
            for my $count ( 0 .. 2 )
            {
                my $sub_n = $n - $max_factor * $count;
                if ( $sub_n < 0 )
                {
                    last COUNT;
                }
                $ret += recurse( $sub_n, ( $max_factor >> 1 ) );
            }

            $ret;
            }
    );

    return $ret;
}

my ( $msb, $next_msb );

if (1)
{
    my $N = ( 10**25 );
    $msb      = 1;
    $next_msb = ( $msb << 1 );
    while ( $next_msb < $N )
    {
        $msb = $next_msb->copy;
        $next_msb <<= 1;
    }
    print "N=$N Count=< ", recurse( $N, $msb ), " >\n";
}
else
{
    my $i = 1;
    $msb      = 1;
    $next_msb = ( $msb << 1 );
    while (1)
    {
        print "I=$i Count=", recurse( $i, $msb ), "\n";
    }
    continue
    {
        $i++;
        if ( $i == $next_msb )
        {
            $msb = $next_msb;
            $next_msb <<= 1;
        }
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
