#!/usr/bin/perl

use strict;
use warnings;

use 5.016;

sub f
{
    my @x = @_;

    my $v = '';
    vec( $v, 0, 1 ) = 1;

    my $n      = 0;
    my $last   = 0;
    my $DELTA  = $x[0] + 1;
    my $target = $last + $DELTA;

    while ( $n < $target )
    {
        if ( vec( $v, $n, 1 ) )
        {
            foreach my $x (@x)
            {
                vec( $v, $n + $x, 1 ) = 1;
            }
        }
        else
        {
            $last   = $n;
            $target = $last + $DELTA;
        }
    }
    continue
    {
        ++$n;
    }
    return $last;
}

sub test
{
    my ( $x, $res ) = @_;
    if ( f(@$x) != $res )
    {
        die "[@$x]!";
    }
    return;
}

test( [ 5, 7 ], 23 );
test( [ 6,  10, 15 ], 29 );
test( [ 14, 22, 77 ], 195 );

my @p = `primesieve -p1 2 5000`;
chomp @p;
@p = map { int $_ } @p;
say $_ for @p;
my $ret = 0;
foreach my $pi ( 0 .. $#p )
{
    my $p = $p[$pi];
    foreach my $qi ( $pi + 1 .. $#p )
    {
        my $q = $p[$qi];
        if (0)
        {
            my $want_res = $p * $q - $p - $q;
            my $res = f( $p, $q );
            say "f( $p , $q ) = $res ; $want_res";
            if ( $want_res != $res )
            {
                die "Foo";
            }
            if ( $qi - $pi > 50 )
            {
                last;
            }

            # next;
        }

        foreach my $ri ( $qi + 1 .. $#p )
        {
            my $r        = $p[$ri];
            my $want_res = $p * $q * $r - $p * ( $q + $r );
            my $res      = f( $p * $q, $p * $r, $q * $r );
            $ret += $res;
            say "Reached [$p,$q,$r] = $res ; $want_res [ sum = $ret ]";
            if ( $want_res > $res )
            {
                die "Flut";
            }
            if ( $res >= 2 * $p * $q * $r )
            {
                die "foo!";
            }
        }
    }
}
say "Result = $ret";

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
