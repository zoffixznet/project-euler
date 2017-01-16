#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

my $last_delta_f = 0;
for my $n ( 1 .. 100 )
{
    my $next_delta_f =
        $last_delta_f + ( $last_delta_f * 9 + ( 10**( $n - 1 ) ) );
    printf "In 0 - %30s delta_f = %30s\n", 10**$n - 1, $next_delta_f;
    $last_delta_f = $next_delta_f;
}
