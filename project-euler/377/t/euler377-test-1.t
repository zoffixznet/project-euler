#!/usr/bin/perl

use strict;
use warnings;

use Euler377;

{
    local $Euler377::BASE = 14;
    @Euler377::N_s = (14);
    # TEST
    Euler377::calc_result();
}
