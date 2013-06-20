#!/usr/bin/perl

use strict;
use warnings;

use integer;
use v5.016;

my $B = 7;

my $power = $B;
my $old_tri_id = 'Triangle[None]';
my $old_tri_sum = 0;
while ($power < 1_000_000_000)
{
    my $next_power = $power * $B;
    my $p_1 = $power - 1;
    my $start = $p_1;
    my $end = $p_1 + $power;
    my $right_tri_sum = $start*($start+1)/2;
    my $right_tri_id = qq#\\|Triangle[$start .. $end]#;
    print qq#$right_tri_id = $start*($start+1)/2 Ys ==> $right_tri_sum\n\n#;

    my $tri_id = qq#Triangle[1 .. $next_power]#;
    my $tri_sum = $B*($B-1)/2*$right_tri_sum + $B*($B+1)/2*$old_tri_sum;
    print qq#$tri_id = (1+2+3+4+5+6) * $right_tri_id + (1+2+3+4+5+6+7) * $old_tri_id = $tri_sum\n\n#;

    $power = $next_power;
    $old_tri_id = $tri_id;
    $old_tri_sum = $tri_sum;
}
