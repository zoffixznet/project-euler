#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 4;

use Euler480;

{
    # TEST
    is (Euler480::calc_P('aaaaaacd'), 8, 
        'Test aaaaaacd');

    # TEST
    is (Euler480::calc_P('aaa'), 3,
        'Test aaa',
    );

    # TEST
    is (Euler480::calc_P('aaaaaacdeeeeeeh'), 17,
        'Test aaaaaacdeeeeeeh',
    );

    # TEST
    is (Euler480::calc_P('euler'), '115246685191495243',
        'Test "euler"',
    );
}

