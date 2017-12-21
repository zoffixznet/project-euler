#!/usr/bin/perl

use strict;
use warnings;

use integer;

my $N = abs( int( $ENV{N} || 1_000_000_000_000 ) );

my $power_of_5 = 5;
my $sum        = 0;
while ( $power_of_5 <= $N )
{
    $sum += int( $N / $power_of_5 );
}
continue
{
    $power_of_5 *= 5;
}
print "There are $sum powers of 5.\n";

my $power_of_2 = 2;
my $sum2       = 0;
while ( $power_of_2 <= $N )
{
    $sum2 += int( $N / $power_of_2 );
}
continue
{
    $power_of_2 *= 2;
}
print "There are $sum2 components of 2.\n";

my $sum_diff = $sum2 - $sum;
print "There are $sum_diff components of 2 excluding those for the digits.\n";

sub get_power_modulo
{
    my ( $modulo, $b, $e ) = @_;

    if ( $e == 0 )
    {
        return 1;
    }

    my $rec_p = get_power_modulo( $modulo, $b, ( $e >> 1 ) );

    my $ret = $rec_p * $rec_p;

    if ( $e & 0x1 )
    {
        $ret *= $b;
    }

    return ( $ret % $modulo );
}

my $FIVE_DIGITS_MOD = 100_000;

sub get_five_digits_mod
{
    my ( $base, $exp ) = @_;
    return get_power_modulo( $FIVE_DIGITS_MOD, $base, $exp );
}

my $powers_2_contribution = get_five_digits_mod( 2, $sum_diff );
print "They contribute $powers_2_contribution to the modulo\n";

my @intermediate_100k_modulos;
my $FINAL_100k_MODULO;

{
    my $mod  = 1;
    my $BASE = 10;
    for my $ten_div ( 0 .. ( $FIVE_DIGITS_MOD / $BASE ) )
    {
        my $ten = $BASE * $ten_div;

        foreach my $add ( 1, 3, 7, 9 )
        {
            my $n = $ten + $add;
            if ( $n <= $FIVE_DIGITS_MOD )
            {
                ( $mod *= $n ) %= $FIVE_DIGITS_MOD;
                $intermediate_100k_modulos[$n] = $mod;
            }
        }
    }
    $FINAL_100k_MODULO = $mod;
}

my $accum_mod = 1;
{
    my $base2 = 1;
    while ( $base2 <= $N )
    {
        my $base2_5 = $base2;
        while ( $base2_5 <= $N )
        {
            my $count = $N / $base2_5;
            my $div   = $count / $FIVE_DIGITS_MOD;
            my $mod   = $count % $FIVE_DIGITS_MOD;
            ( $accum_mod *= get_five_digits_mod( $FINAL_100k_MODULO, $div ) )
                %= $FIVE_DIGITS_MOD;
            print "With Base=$base2_5 AccumMod is now $accum_mod.\n";
            while (( $mod >= 0 )
                && ( !defined( $intermediate_100k_modulos[$mod] ) ) )
            {
                $mod--;
            }
            if ( $mod >= 0 )
            {
                ( $accum_mod *= $intermediate_100k_modulos[$mod] ) %=
                    $FIVE_DIGITS_MOD;
            }
            print "With Base=$base2_5 AccumMod[AfterMod] is now $accum_mod.\n";
        }
        continue
        {
            $base2_5 *= 5;
        }
    }
    continue
    {
        $base2 *= 2;
    }
}
print "Final AccumMod = $accum_mod\n";
my $final_result =
    ( ( $powers_2_contribution * $accum_mod ) % $FIVE_DIGITS_MOD );
print "Final Mod = $final_result\n";

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
