#!/usr/bin/perl

use strict;
use warnings;

use Math::BigRat ( try => 'GMP' );

use bytes;

use List::Util qw(sum);
use List::MoreUtils qw(none);

STDOUT->autoflush(1);

my @is_prime = (
    0, 0,
    (
        map {
            my $p = $_;
            ( none { $p % $_ == 0 } 2 .. $p - 1 ) ? 1 : 0
        } 2 .. 500
    ),
    0
);

my @p_letter = ( map { $_ ? 'P' : 'N' } @is_prime );

my @init_probab = ( 0, ( ( Math::BigRat->new('1/500') ) x 500 ), 0 );

my @up_step_probab   = ( 0, 1, ( ( Math::BigRat->new('1/2') ) x 498 ), 0, 0 );
my @down_step_probab = ( 0, 0, ( ( Math::BigRat->new('1/2') ) x 498 ), 1, 0 );
my $s                = 'PPPPNNPPPNPPNPN';

my @probab = @init_probab;
my $T_frac = Math::BigRat->new('2/3');
my $F_frac = Math::BigRat->new('1/3');

sub f
{
    my ( $k, $idx, $step ) = @_;

    return ( $step->[$idx] *
            $probab[$idx] *
            ( $k eq $p_letter[$idx] ? $T_frac : $F_frac ) );
}

for my $k ( split //, $s )
{
    my @next_probab = (
        0,
        (
            map {
                my $i = $_;
                ( f( $k, $i - 1, \@up_step_probab ) +
                        f( $k, $i + 1, \@down_step_probab ) );
            } 1 .. 500
        ),
        0
    );

    @probab = @next_probab;
}

my $sum = Math::BigRat->new('0/1');

foreach my $x (@probab)
{
    $sum += $x;
}

print $sum, "\n";

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
