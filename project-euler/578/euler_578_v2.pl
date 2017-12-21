#!/usr/bin/perl

use strict;
use warnings;

use 5.022;

no warnings 'recursion';

sub pow
{
    my ( $b, $e ) = @_;

    my $r = 1;
    foreach my $x ( 1 .. $e )
    {
        $r *= $b;
    }
    return $r;
}

# my $LIM = 1_000_000_000_000_000;
my $LIM = 1_000_000;

# my $LIM = 100;

my $SQ = int( sqrt( $LIM / 2 ) );

my @P = ( map { int } `primes 2 @{[int($LIM/(2*3*3))+1]}` );

my $MAX_POWER = int( log($LIM) / log(2) );
foreach my $first_power ( 1 .. $MAX_POWER )
{
I:
    foreach my $i ( keys @P )
    {
        my $p = pow( $P[$i], $first_power );
        if ( $p > $LIM )
        {
            last I;
        }
        foreach my $second_power ( $first_power + 1 .. $MAX_POWER )
        {
        J:
            foreach my $j ( $i + 1 .. $#P )
            {
                my $p2 = pow( $P[$j], $second_power );
                my $t = $p * $p2;
                if ( $t > $LIM )
                {
                    last J;
                }
                my $rec;
                $rec = sub {
                    my ( $k, $p ) = @_;
                    my $g = $P[$k];
                    if ( $k == @P or $p * $g > $LIM )
                    {
                        return;
                    }

                    # say "b=$b";
                    $rec->( $k + 1, $p );
                    if ( ( $k == $i ) or ( $k == $j ) )
                    {
                        return;
                    }
                    while ( $p <= $LIM )
                    {
                        $p *= $g;
                        if ( $p <= $LIM )
                        {
                            say $p;
                            $rec->( $k + 1, $p );
                        }
                    }
                    return;
                };
                say $t;
                $rec->( 0, $t );
                undef($rec);
            }
        }
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
