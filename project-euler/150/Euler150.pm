package Euler150::S;

use strict;
use warnings;

use integer;

my $t = 0;

sub get
{
    $t = ( ( 615949 * $t + 797807 ) & ( ( 1 << 20 ) - 1 ) );
    return ( $t - ( 1 << 19 ) );
}

package Euler150;

use strict;
use warnings;

use integer;

use List::Util qw(min);

sub solve
{
    my @sums = ();
    my $min  = 0;

    foreach my $row_idx ( 0 .. ( 1_000 - 1 ) )
    {
        print "Checking row $row_idx\n";
        my $row_sum = 0;
        my @row     = ($row_sum);
        foreach my $i ( 0 .. $row_idx )
        {
            push @row, ( $row_sum += Euler150::S::get() );
        }

        my $tri_idx = 0;
        foreach my $r ( 0 .. $row_idx )
        {
            foreach my $col ( 0 .. $r )
            {
                $min = min(
                    $min,
                    (
                        $sums[$tri_idx] +=
                            $row[ $col + $row_idx - $r + 1 ] - $row[$col]
                    )
                );
                $tri_idx++;
            }
        }
        print "Min = $min\n";
    }
}
1;
