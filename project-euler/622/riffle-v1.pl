#!/usr/bin/perl

use strict;
use warnings;
use integer;

sub riff
{
    my ( $p, $half ) = @_;

    my $ret = $p << 1;
    my $MOD = ( ( $half << 1 ) - 1 );

    return $ret % $MOD;

    # return (
    #    ( $ret >= ( $half << 1 ) ) ? $ret - ( ( $half << 1 ) - 1 ) : $ret );

    # return ( ( ( $p % $half ) << 1 ) | ( $p >= $half ) );
}

sub riffle
{
    my $in = shift;

    my $half = @$in >> 1;

    my @ret;
    foreach my $i ( 0 .. $half - 1 )
    {
        push @ret, @$in[ $i, $half + $i ];
    }
    return \@ret;
}

my $sum = 0;

sub multi
{
    my $half = shift;
    my $WANT = 1;
    my $x    = riff( $WANT, $half );
    my $i    = 1;
    while ( $x != $WANT )
    {
        # print map { "$_: $x->[$_]\n" } keys @$x;
        # print "n=$half x1=$x\n";
        $x = riff( $x, $half );
        if ( ++$i > 60 )
        {
            # print STDERR "Flut\n";
            return;
        }
    }
    if ( $i == 60 )
    {
        my $n = ( $half << 1 );
        $sum += $n;
        print "$i = $n ( $sum )\n";
    }
    return;
}

my $N = (1 << 60) - 1;
my @S = map { (1 << $_) - 1 } grep { 60 % $_ == 0 } 1 .. 59;
sub multi2
{
    my $half = shift;
    my $MOD = ( ( $half << 1 ) - 1 );

    if ($N % $MOD == 0 and !grep { $_ % $MOD == 0 } @S)
    {
        my $n = ( $half << 1 );
        $sum += $n;
        print "60 = $n ( $sum )\n";
    }
    return;
}

STDOUT->autoflush(1);
my $n = 0;
while (1)
{
    # print "n=$n\n";
    multi2( ++$n );
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
