#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Data::Dumper;

use List::Util qw(sum);
use List::MoreUtils qw(any none);

STDOUT->autoflush(1);

my @Graph;
foreach my $inputs (0 .. (2**6-1))
{
    my ($aa, $bb, $cc, $dd, $ee, $ff) = split//, sprintf"%06b", $inputs;
    my $new = eval ("0b$bb$cc$dd$ee$ff" . (($aa xor ($bb && $cc)) ? '1' : '0'));
    push @{$Graph[$inputs]}, $new;
    push @{$Graph[$new]}, $inputs;
}

foreach my $node (@Graph)
{
    $node = [sort { $a <=> $b } @$node];
}


# Find Fully-connected components (FCCs).

my @FCCs = ([]);

my %to_traverse = (map { $_ => 1 } keys @Graph);

foreach my $inputs (0 .. (2**6-1))
{
    my @q = ($inputs);
    while (defined  ( my $i = shift(@q)) )
    {
        if (exists($to_traverse{$i}))
        {
            delete $to_traverse{$i};
            push @{$FCCs[-1]}, $i;
            push @q, @{$Graph[$i]};
        }
    }

    if (@{$FCCs[-1]})
    {
        $FCCs[-1] = [ sort { $a <=> $b } @{$FCCs[-1]} ];
        push @FCCs, []
    }
}

if (! @{$FCCs[-1]})
{
    pop(@FCCs);
}

my @counts;
# This is $counts[$length][$start_bit][$end_bit].
$counts[1][0][0] = 1;
$counts[1][1][1] = 1;
$counts[1][0][1] = 0;
$counts[1][1][0] = 0;

for my $len (2 .. 63)
{
    my $prev_len = $len-1;
    my $p = $counts[$prev_len];
    $counts[$len][0][0] = $p->[0][0] + $p->[0][1];
    $counts[$len][0][1] = $p->[0][0];
    $counts[$len][1][0] = $p->[1][0] + $p->[1][1];
    $counts[$len][1][1] = $p->[1][0];
}

sub find_circular
{
    my ($l) = @_;

    my $r = $counts[$l];
    return $r->[0][0] + $r->[1][0] + $r->[0][1];
}

my $result = 1;

foreach my $fcc (@FCCs)
{
    # We know from viewing the graph (see the Makefile) that all the FCCs
    # are singly-circular.
    $result *= find_circular(scalar ( @$fcc ));
}

print "Result == $result\n";
