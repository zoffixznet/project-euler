use strict;
use warnings;

use List::MoreUtils (qw(all));

my %Cache = ( 1 => 0 );

sub num_distinct_factors
{
    my $n = shift;
    my $start_from = shift;

    if (not exists($Cache{$n}))
    {
        my $d = $n;
        while ($d % $start_from)
        {
            $start_from++;
        }
        while ($d % $start_from == 0)
        {
            $d /= $start_from;
        }
        $Cache{$n} = 1 + num_distinct_factors($d, $start_from+1)
    }
    return $Cache{$n};
}

for my $check (647 .. 315720)
{
    print "Checking $check\n" if ($check % 10_000 == 0);
    if (all 
        { num_distinct_factors($_, 2) == 4}
        ($check .. $check+3)
    )
    {
        print "Found $check\n";
        exit(0);
    }
}

