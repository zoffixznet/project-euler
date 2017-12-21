#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(max sum);
use List::MoreUtils qw();

my @drs;
my @factors;

sub _digi_root
{
    my ($n) = @_;

    my $ret = sum( split //, $n );

    if ( $ret >= 10 )
    {
        $ret = _digi_root($ret);
    }

    return $ret;
}

my $MAX = 999_999;
my $sum = 0;
for my $n ( 2 .. $MAX )
{
    my $f = $factors[$n];

    # If $n is prime.
    my $result = _digi_root($n);
    if ( defined($f) )
    {
        $result = max( $result, map { $drs[$_] + $drs[ $n / $_ ] } @$f );
    }
    $sum += ( $drs[$n] = $result );

    my $product = $n * $n;
    while ( $product <= $MAX )
    {
        push @{ $factors[$product] }, $n;
    }
    continue
    {
        $product += $n;
    }
    print "Reached N=$n Sum=$sum\n";
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
