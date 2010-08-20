package main;

use strict;
use warnings;

=head1 DESCRIPTION

The points P (x_(1), y_(1)) and Q (x_(2), y_(2)) are plotted at integer 
co-ordinates and are joined to the origin, O(0,0), to form ΔOPQ.

There are exactly fourteen triangles containing a right angle that can be formed when each co-ordinate lies between 0 and 2 inclusive; that is,
0 ≤ x_(1), y_(1), x_(2), y_(2) ≤ 2.

Given that 0 ≤ x_(1), y_(1), x_(2), y_(2) ≤ 50, how many right triangles can
be formed?

=head1 ANALYSIS

One can see that the right angle can be:

=head2 In O.

In this case, there are x_len * y_len triangles.

=cut

sub get_num_O_right_angle_triangles
{
    my ($x_len, $y_len) = @_;

    return $x_len * $y_len;
}

1;

