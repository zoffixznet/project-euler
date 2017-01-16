#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 15;

use Test::Differences (qw( eq_or_diff ));

use Euler480;

{
    # TEST
    is_deeply(
        Euler480::_weights_from_proto( [qw(5 5 1 1 1 1 1)], ),
        [ [ 5, 2 ], [ 1, 5 ] ],
        "_weights_from_proto works fine",
    );

    # TEST
    is( Euler480::calc_P('aaaaaacd'), 8, 'Test aaaaaacd' );

    # TEST
    is( Euler480::calc_P('aaa'), 3, 'Test aaa', );

    # TEST
    is( Euler480::calc_P('aaaaaacdeeeeeef'), 15, 'Test aaaaaacdeeeeeef', );

    # TEST
    is( Euler480::calc_P('aaaaaacdeeeeeeg'), 16, 'Test aaaaaacdeeeeeeg', );

    # TEST
    is( Euler480::calc_P('aaaaaacdeeeeeeh'), 17, 'Test aaaaaacdeeeeeeh', );

    # TEST
    is( Euler480::calc_P('aaaaaacdeeeeeey'), 28, 'Test aaaaaacdeeeeeey', );

    # TEST
    is( Euler480::calc_P('aaaaaacdeeeeef'), 29, 'Test aaaaaacdeeeeef', );

    # TEST
    is( Euler480::calc_P('aaaaaacdeeeeefe'), 30, 'Test aaaaaacdeeeeefe', );

    # TEST
    is( Euler480::calc_P('euler'), '115246685191495243', 'Test "euler"', );

    # TEST
    is(
        Euler480::calc_P('euleoywuttttsss'),
        '115246685191495242', 'Test "euleoywuttttsss"',
    );

    # TEST
    is( Euler480::calc_P('eulera'), '115246685191495244', 'Test "eulera"', );

    # TEST
    is(
        Euler480::calc_P('ywuuttttssssrrr'),
        '525069350231428029', 'Test "ywuuttttssssrrr"',
    );

    # TEST
    is(
        Euler480::calc_W('115246685191495243'),
        'euler', 'Test calc_W - "euler"',
    );

    # TEST
    is(
        Euler480::calc_W('525069350231428029'),
        'ywuuttttssssrrr', 'Test calc_W - "ywuuttttssssrrr"',
    );
}

