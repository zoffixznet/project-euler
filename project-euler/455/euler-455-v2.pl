#!/usr/bin/perl

use strict;
use warnings;
use autodie;

use 5.016;

use integer;
use bytes;

my $MOD = 1_000_000_000;

sub exp_mod
{
    my ( $b, $e ) = @_;

    if ( $e == 0 )
    {
        return 1;
    }

    my $rec_p = exp_mod( $b, ( $e >> 1 ) );

    my $ret = $rec_p * $rec_p;

    if ( $e & 0x1 )
    {
        $ret *= $b;
    }

    return ( $ret % $MOD );
}

sub calc_f
{
    my ($n) = @_;

    if ( $n % 10 == 0 )
    {
        return 0;
    }

    my $cache = '';

    my $e     = 0;
    my $power = 1;

    # Find the first cycle len.
    while ( !vec( $cache, $power, 1 ) )
    {
        vec( $cache, $power, 1 ) = 1;
    }
    continue
    {
        $e++;
        ( $power *= $n ) %= $MOD;
    }

    my $found_power = $power;
    my $found_e     = $e;

    $power = 1;
    $e     = 0;
    while ( $power != $found_power )
    {
        $e++;
        ( $power *= $n ) %= $MOD;
    }

    my $cycle_len = $found_e - $e;

    $power = 1;
    my $x = 0;
    for my $e2 ( 0 .. $found_e )
    {
        if ( ( $power - $e2 ) % $cycle_len == 0
            and $power > $x )
        {
            $x = $power;
        }
    }
    continue
    {
        ( $power *= $n ) %= $MOD;
    }

    print "f($n) == $x\n";

    return $x;
}

my $MAX = 1_000_000;
my $sum = 0;

my ( $START, $END ) = @ARGV;

STDOUT->autoflush(1);

foreach my $n ( $START .. $END )
{
    $sum += calc_f($n);
}

say "Sum == $sum";

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
