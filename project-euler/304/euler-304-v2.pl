package Row;

use strict;
use warnings;
use autodie;

# use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

sub mark_primes
{
    my ($start, $top) = @_;

    my $top_prime = int(sqrt($top));

    my $buf = '';
    open my $primes_fh, "primes 2 '$top_prime'|";
    while (my $p = <$primes_fh>)
    {
        chomp($p);
        print "P=$p\n";
        my $i = $start;
        my $m = $i % $p;
        if ($m != 0)
        {
            $i += $p-$m;
        }

        for(; $i<=$top ; $i += $p)
        {
            vec ($buf, $i-$start, 1) = 1;
        }
    }
    close($primes_fh);

    return \$buf;
}

my $count = 0;
my $LIMIT = 100_000;

my $SIZE = 10_000_000;
my $start = 100_000_000_000_001;
my $end = $start+$SIZE;
MAIN:
while (1)
{
    my $buf = mark_primes($start, $end);
    my $n = $start;
    while ($count < $LIMIT and $n <= $end)
    {
        if (not vec($$buf, $n-$start, 1))
        {
            print "Found $n\n";
            if (++$count == $LIMIT)
            {
                last MAIN;
            }
        }
    }
    continue
    {
        $n++;
    }
    $start = $end + 1;
    $end = $start+$SIZE;
}
