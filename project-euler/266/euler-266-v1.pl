#!/usr/bin/perl

use strict;
use warnings;

use Math::GMP;
use bytes;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

# Prime strings.
my @p_s = `primes 2 190`;
chomp(@p_s);

# The primes.
my @p = ( map { Math::GMP->new($_) } @p_s );

my $n = Math::GMP->new(1);
$n *= $_ foreach @p;

my $sq = $n->bsqrt;

my $max = 1;

my @s = (0);

# Count limit
my $L = 1;

sub rec
{
    # Depth and product (multiplication)
    my ( $d, $m ) = @_;

    if ( $m > $sq )
    {
        print "[G]Found $max [ " . join( '*', @p_s[ @s[ 0 .. $d ] ] ) . " ]\n";
        return 0;
    }

    if ( $m > $max )
    {
        $max = $m;
        print "Found $max [ " . join( '*', @p_s[ @s[ 0 .. $d ] ] ) . " ]\n";
    }

    my $D = $d + 1;

    if ( $D == $L )
    {
        return 1;
    }

    my $x = 0;
    for my $n ( $s[$d] + 1 .. $#p )
    {
        $s[$D] = $n;
        if ( !rec( $D, $m * $p[$n] ) )
        {
            return $x;
        }
    }
    continue
    {
        $x++;
    }

    return $x;
}

for my $limit ( reverse( 1 .. @p ) )
{
    $L = $limit;
    for my $initial ( 0 .. $#p )
    {
        $s[0] = $initial;
        rec( 0, $p[$initial] );
    }
}

print "Max = $max\n";

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
