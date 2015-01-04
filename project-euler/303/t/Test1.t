#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 5;

use Euler303_Take1 (qw( f_div f_complete ));

{

    # TEST
    is (f_complete(2), 2, "f_complete for 2");

    # TEST
    is (f_complete(3), 12, "f_complete for 3");
    
    # TEST
    is (f_complete(7), 21, "f_complete for 7");
    
    # TEST
    is (f_complete(42), 210, "f_complete for 42");

    # TEST
    is (f_complete(89), 1121222, "f_complete for 89");

}

