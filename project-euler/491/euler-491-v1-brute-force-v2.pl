#!/usr/bin/perl

use strict;
use warnings;

my ($MAX_DIGIT) = @ARGV;


sub rec
{
    my ($s, $r) = @_;

    if (! @$r)
    {
        if ( $s % 11 == 0)
        {
            print "$s\n";
        }
    }
    else
    {
        for my $i (0 .. $#$r)
        {
            rec($s.$r->[$i], [ @$r[grep { $_ != $i } keys@$r] ],);
        }
    }
    return;
}

my $r = [(0 .. $MAX_DIGIT), (0 .. $MAX_DIGIT)];
my $s = '';
for my $i (1 .. $MAX_DIGIT)
{
    rec($s.$r->[$i], [ @$r[grep { $_ != $i } keys@$r] ]);
}
