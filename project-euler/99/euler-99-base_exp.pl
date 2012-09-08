#!/usr/bin/perl

use strict;
use warnings;

use IO::All;

my $max_line_num = 0;
my $max_log = 1;

my $line_num = 1;
foreach my $l (io->file("../base_exp.txt")->chomp->getlines())
{
    my ($base, $exp) = split(/,/, $l);

    my $log = log($base) * $exp;

    if ($log > $max_log)
    {
        $max_log = $log;
        $max_line_num = $line_num;
    }
}
continue
{
    $line_num++;
}

print "$max_line_num\n";

