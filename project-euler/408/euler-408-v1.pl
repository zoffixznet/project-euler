#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $is_sq = '';

my $LIM = shift(@ARGV);
my $MOD = 1_000_000_007;
for my $x ( 0 .. sqrt( 2 * $LIM ) )
{
    vec( $is_sq, $x * $x, 1 ) = 1;
}
my $STEP = 25;
my $MAJ  = 1_000;
my $p    = $STEP;
my $mp   = $MAJ;

# $prev maps ($x) => P($x, $path_len-$x)
my $prev = [1];

sub gen
{
    my ( $path_len, $min_x, $max_x, $y ) = @_;

    my @r;
    my $i = 0;
    if ( vec( $is_sq, $path_len, 1 ) )
    {
        for my $x ( $min_x .. $max_x )
        {
            push @r,
                (
                ( vec( $is_sq, $x, 1 ) && vec( $is_sq, $y, 1 ) )
                ? 0
                : ( ( $prev->[$i] + $prev->[ $i + 1 ] ) )
                );
        }
        continue
        {
            $y--;
            $i++;
        }
    }
    else
    {
        for my $i ( 0 .. $max_x - $min_x )
        {
            push @r, ( ( $prev->[$i] + $prev->[ $i + 1 ] ) );
        }
    }
    return \@r;
}

sub step
{
    if ( $mp == $p )
    {
        print "Reached $p\n";
        $mp += $MAJ;
    }
    $p += $STEP;
    for (@$prev) { $_ %= $MOD; }
}

for my $path_len ( 1 .. $LIM )
{
    my @N = (
        $prev->[0], @{ gen( $path_len, 1, ( $path_len - 1 ) x 2 ) },
        $prev->[-1]
    );
    print "Prev = [@$prev] ; Next = [@N]\n";
    $prev = \@N;

    if ( $p == $path_len ) { step(); }
}

my $max_x = $LIM;
my $max_y = $LIM;
my $min_x = 1;
for my $path_len ( $LIM + 1 .. ( ( $LIM << 1 ) ) )
{
    my $N = gen( $path_len, $min_x, $max_x, $max_y );
    $min_x++;
    print "Prev = [@$prev] ; Next = [@$N]\n";
    $prev = $N;
    if ( $p == $path_len ) { step(); }
}

step();
print "Result = ", $prev->[0], "\n";

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
