#!/usr/bin/perl

use strict;
use warnings;

use Graph::Undirected;
use IO::All;

my $g = Graph::Undirected->new;

my $line_num = 0;

my $orig_sum = 0;
foreach my $l ( io("network.txt")->chomp->getlines() )
{
    my @data = split( /,/, $l );

    # Add only the lower triangle of the matrix
    foreach my $i ( 0 .. $line_num )
    {
        my $w = $data[$i];
        if ( $w ne "-" )
        {
            $orig_sum += $w;
            $g->add_weighted_edge( $i, $line_num, $w );
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

print
"Orig sum = $orig_sum ; MST sum = $mst_sum ; Diff = @{[$orig_sum - $mst_sum]}\n";

=head1 COPYRIGHT & LICENSE

Copyright 2018 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

=cut
