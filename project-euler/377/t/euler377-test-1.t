#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 10;

use List::MoreUtils qw/all/;

use Euler377;

sub gen_id_mat
{
    return [
        map {
            my $i = $_;
            [ map { ( ( $_ == $i ) ? 1 : 0 ); } @Euler377::DIGITS ]
        } @Euler377::DIGITS
    ];
}

{
    my $ID_MAT = gen_id_mat();
    my $result = Euler377::multiply( $ID_MAT, $ID_MAT, );

    # TEST
    ok(
        scalar(
            all
            {
                my $i = $_;
                all
                {
                    my $j = $_;
                    ( $result->{normal}->[$i]->[$j] ==
                            ( ( $i == $j ) ? 1 : 0 ) );
                }
                @Euler377::DIGITS;
            }
            @Euler377::DIGITS
        ),
        "id * id == id",
    );
}

{
    # TEST
    is( '' . Euler377->new->calc_count(1), 1, "count(1) is correct." );

    # TEST
    is( '' . Euler377->new->calc_count(2), 2, "count(2) is correct." );

    # TEST
    is(
        '' . Euler377->new->calc_count(3),
        scalar(
            @{
                [
                    qw(
                        111
                        12
                        21
                        3
                        )
                ]
            }
        ),
        "count(2) is correct."
    );

    # TEST
    is( '' . Euler377->new->calc_count(5), 16, "count(5) is correct." );
}

sub test_single_calc_result
{
    my ( $BASE, $blurb ) = @_;

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my $obj = Euler377->new( { BASE => $BASE, N_s => [$BASE] } );
    return is( $obj->calc_result(),
        ( $obj->calc_using_brute_force($BASE) % 1_000_000_000 ), $blurb, );
}

{
    # TEST
    test_single_calc_result( 13, "Good calc result for 13" );

    # TEST
    test_single_calc_result( 14, "Good calc result for 14" );

    # TEST
    test_single_calc_result( 15, "Good calc result for 15" );

    # TEST
    test_single_calc_result( 16, "Good calc result for 16" );

    # TEST
    test_single_calc_result( 17, "Good calc result for 17" );
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
