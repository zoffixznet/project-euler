#!/usr/bin/perl

use strict;
use warnings;

use integer;
use v5.016;

my $B = 7;

my $power = $B;
my $old_tri_id = 'Triangle[None]';
my $old_tri_sum = 0;

my @stack = ();

my $LIMIT = 1_000_000_000;
# my $LIMIT = 100;

while ($power < $LIMIT)
{
    my $next_power = $power * $B;
    my $p_1 = $power - 1;
    my $start = $p_1;
    my $end = $p_1 + $power;
    my $right_tri_sum = $start*($start+1)/2;
    my $right_tri_id = qq#\\|Triangle[$start .. $end]#;
    print qq#$right_tri_id = $start*($start+1)/2 Ys ==> $right_tri_sum\n\n#;

    IMPROPER_TRI:
    for my $h (2 .. $B-1)
    {
        my $improper_tri_sum = $old_tri_sum*$h*($h+1)/2 + $right_tri_sum*$h*($h-1)/2;
        print qq#    ==> ImproperTriangle[1 .. @{[$power]}*$h] == ImproperTriangle[1 .. @{[$power*$h]}] = $old_tri_id * (@{[join('+',1..$h)]}) + $right_tri_id * (@{[join('+',1..$h-1)]}) = $improper_tri_sum\n\n#;

        if ($power * $h + $power > $LIMIT)
        {
            for my $sub_h (1 .. $B-1)
            {
                my $num_tris = $h+1;
                my $num_right_tris = $h;

                my $num_sub_tris_per_tri = (1+$sub_h)*$sub_h/2;
                my $num_sub_right_tris_per_tri = ($sub_h-1)*$sub_h/2;

                my $height = $sub_h*$stack[-1]{power};
                my $added_diff = $num_tris *
                    ($num_sub_right_tris_per_tri * $stack[-1]{right_tri_sum} +
                        $num_sub_tris_per_tri * $stack[-1]{tri_sum}
                    )
                    +
                    $num_right_tris * (($p_1 + ($power-$height))*$height/2)
                    ;
                print qq#       ==> ImproperImproperTriangle[1 .. @{[$power * $h + $height]}] = @{[$improper_tri_sum + $added_diff]}\n\n#;

            }
            last IMPROPER_TRI;
        }
    }

    my $tri_id = qq#Triangle[1 .. $next_power]#;
    my $tri_sum = $B*($B-1)/2*$right_tri_sum + $B*($B+1)/2*$old_tri_sum;
    print qq#$tri_id = (1+2+3+4+5+6) * $right_tri_id + (1+2+3+4+5+6+7) * $old_tri_id = $tri_sum\n\n#;

    push @stack, { power => $power, tri_sum => $old_tri_sum, tri_id => $old_tri_id, right_tri_id => $right_tri_id, right_tri_sum => $right_tri_sum};

    $power = $next_power;
    $old_tri_id = $tri_id;
    $old_tri_sum = $tri_sum;
}
