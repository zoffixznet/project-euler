package Row;

use strict;
use warnings;
use autodie;

# use integer;
use bytes;

use Math::BigInt lib => 'GMP';

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

my $BASE = 1234567891011;

my %cache;

sub get_mod_fibo
{
    my ($n) = @_;
    # Matrix is
    # |0 1|
    # |1 1|

    my $multiply = sub {
        my ($p_m0, $p_m1) = @_;

        my $m0 = [map { Math::BigInt->new($_) } @$p_m0];
        my $m1 = [map { Math::BigInt->new($_) } @$p_m1];

        my $mult = sub {
            my ($row, $col) = @_;
            return (($m0->[$row*2] * $m1->[$col] + $m0->[$row*2+1] * $m1->[$col+2]) % $BASE);
        };

        return [$mult->(0, 0), $mult->(0, 1), $mult->(1,0), $mult->(1,1)];
    };

    my $get_matrix;

    $get_matrix = sub {
        my ($n) = @_;

        return $cache{$n} //= (sub {
            if ($n == 1)
            {
                return [0,1,1,1];
            }
            else
            {
                my $m = $get_matrix->($n >> 1);
                my $ret = $multiply->($m, $m);
                if ($n & 0x1)
                {
                    $ret = $multiply->($ret, $get_matrix->(1));
                }
                return $ret;
            }
        }->());
    };

    if ($n <= 1)
    {
        return $n;
    }
    else
    {
        my $m = $get_matrix->($n-1);

        return $m->[0]+$m->[2];
    }
}

for my $i (0 .. 100)
{
    print "fib[$i] == ", get_mod_fibo($i), "\n";
}

my $count = 0;
my $LIMIT = 100_000;

my $SIZE = 10_000_000;
my $start = 100_000_000_000_001;
my $end = $start+$SIZE;
my $sum = 0;
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
            ($sum += get_mod_fibo($n)) %= $BASE;
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

print "Result = $sum\n";
