#!/usr/bin/perl

use strict;
use warnings;

# use integer;
use bytes;

# use Math::BigInt lib => 'GMP';
# use Math::BigRat lib => 'GMP';
#
# use Math::GMPq qw(:mpq);

use List::Util qw(sum);
use List::MoreUtils qw();
use List::UtilsBy qw(max_by);

STDOUT->autoflush(1);

my $MAX = shift(@ARGV) // 10_000;

my $sum = 0;

sub gcd
{
    my ( $n, $m ) = @_;

    if ( $n < $m )
    {
        return gcd( $m, $n );
    }

    if ( $m == 0 )
    {
        return $n;
    }

    return gcd( $m, $n % $m );
}

=begin foo

sub _exp
{
    my ($q, $e) = @_;

    if ($e == 0)
    {
        my $one = Rmpq_init;
        Rmpq_set_str($one, "1/1", 10);
        return $one;
    }
    my $rec = $e >> 1;
    my $d = _exp($q, $rec);
    $d = $d * $d;
    if ($e & 0x1)
    {
        $d *= $q;
    }

    return $d;
}

=end foo

=cut

for my $N ( 5 .. $MAX )
{
    if ( $N % 100 == 0 )
    {
        print "N=$N\n";
    }

=begin foo

    my $k = 1;
    my $max_q = Rmpq_init();
    Rmpq_set_str($max_q, "$N/1", 10);
    for my $i (2 .. $N-1)
    {
        my $q = Rmpq_init();
        Rmpq_set_str($q, "$N/$i", 10);
        my $prod = _exp($q, $i);

        if (Rmpq_cmp($prod, $max_q) > 0)
        {
            $max_q = $prod;
            $k = $i;
        }
    }

=end foo

=cut

    my $logN = log($N);
    my $k = max_by { $_ * ( $logN - log($_) ) } ( 1 .. ( $N - 1 ) );

    # M($N) == ($N/$k) ** $k
    my $g = gcd( $N, $k );

    my $k_to_check = $k / $g;

    while ( $k_to_check % 5 == 0 )
    {
        $k_to_check /= 5;
    }

    while ( ( $k_to_check & 0x1 ) == 0 )
    {
        $k_to_check >>= 1;
    }

    my $diff = ( ( $k_to_check == 1 ) ? ( -$N ) : $N );

    # print "N=$N ; Diff=$diff ; k_to_check=$k_to_check\n";
    $sum += $diff;
}

print "Sum = $sum\n";

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
