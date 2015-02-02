#!/usr/bin/perl

use strict;
use warnings;

foreach my $inputs (0 .. (2**6-1))
{
    my ($aa, $bb, $cc, $dd, $ee, $ff) = split//, sprintf"%06b", $inputs;
    print "$aa$bb$cc$dd$ee$ff => $bb$cc$dd$ee$ff" . (($aa ^ ($bb & $cc)) ? '1' : '0') . "\n";
}
