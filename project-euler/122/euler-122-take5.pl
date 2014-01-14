#!/usr/bin/perl

use strict;
use warnings;

use integer;

use List::MoreUtils qw(uniq);
use List::Util qw(min sum);
use List::UtilsBy qw(min_by);
use IO::Handle;

STDOUT->autoflush(1);

my $comb1 = '';
vec($comb1, 1, 1) = 1;

my @compositions = (undef, { comp => $comb1, rank => 0,},);

my @compositions_by_rank = (undef, [$comb1]);

my $num_filled = 1;

my $limit = 200;

FILL_LOOP:
for (my $base_rank = 1; ; $base_rank++)
{
    foreach my $comp (@{$compositions_by_rank[$base_rank]})
    {
        my $vec = unpack("b*", $comp);
        my @nums = grep { substr($vec,$_,1) eq "1" } (1 .. length($vec)-1);

        my $max_num = $nums[-1];

        LOWER_NUM:
        foreach my $lower_num (reverse(@nums))
        {
            my $reached = $max_num+$lower_num;
            my $new_comp = $comp;

            if ($reached > $limit)
            {
                next LOWER_NUM;
            }
            vec($new_comp, $reached, 1) = 1;

            if (!$compositions[$reached])
            {
                $compositions[$reached] =
                    { comp => $new_comp, rank => ($base_rank+1-1) }
                    ;
                print "Found ", $base_rank+1-1, " for $reached\n";
                if (++$num_filled == $limit)
                {
                    print "Found all!\n";
                    last FILL_LOOP;
                }
            }

            push @{$compositions_by_rank[$base_rank+1]}, $new_comp;
        }
    }
}

print "Sum is " .
    sum (
        map { $_->{rank} } @compositions[ 1 .. $#compositions]
    ) . "\n"
    ;

