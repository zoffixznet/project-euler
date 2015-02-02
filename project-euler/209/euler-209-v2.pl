#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use List::Util qw(sum);
use List::MoreUtils qw(none);

STDOUT->autoflush(1);

my @Graph;
foreach my $inputs (0 .. (2**6-1))
{
    my ($aa, $bb, $cc, $dd, $ee, $ff) = split//, sprintf"%06b", $inputs;
    my $new = eval ("0b$bb$cc$dd$ee$ff" . (($aa ^ ($bb & $cc)) ? '1' : '0'));
    push @{$Graph[$inputs]}, $new;
    push @{$Graph[$new]}, $inputs;
}

foreach my $node (@Graph)
{
    $node = [sort { $a <=> $b } @$node];
}

sub recurse
{
    my ($queue, $state) = @_;

    if (!@$queue)
    {
        return 1;
    }

    my ($inputs, @newQ) = @$queue;

    my @newS = @$state;
    $newS[$inputs] = 0;

    my $ret = recurse((\@newQ), \@newS);

    if (none { $state->[$_] == 1 } @{$Graph[$inputs]})
    {
        $newS[$inputs] = 1;
        $ret += recurse((\@newQ), \@newS);
    }

    return $ret;
}

# Find Fully-connected components.
