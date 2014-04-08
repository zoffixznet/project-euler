#!/usr/bin/perl

use strict;
use warnings;

use Graph::Undirected;
use IO::All;

my $g = Graph::Undirected->new;

my $line_num = 0;

my $orig_sum = 0;
foreach my $l (io("network.txt")->chomp->getlines())
{
    my @data = split(/,/, $l);

    # Add only the lower triangle of the matrix
    foreach my $i (0 .. $line_num)
    {
        my $w = $data[$i];
        if ($w ne "-")
        {
            $orig_sum += $w;
            $g->add_weighted_edge($i, $line_num, $w);
        }
    }
}
continue
{
    $line_num++;
}

my $mst = $g->MST_Prim();

my @E = $mst->edges();

my $mst_sum = 0;
foreach my $edge (@E)
{
    $mst_sum += $mst->get_edge_weight(@$edge);
}

print "Orig sum = $orig_sum ; MST sum = $mst_sum ; Diff = @{[$orig_sum - $mst_sum]}\n";
