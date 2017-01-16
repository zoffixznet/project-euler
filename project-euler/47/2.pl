use strict;
use warnings;

use List::MoreUtils (qw(all));

my %Cache = ( 1 => 0 );

sub num_distinct_factors
{
    my $n          = shift;
    my $start_from = shift;

    if ( not exists( $Cache{$n} ) )
    {
        my $d = $n;
        while ( $d % $start_from )
        {
            $start_from++;
        }
        while ( $d % $start_from == 0 )
        {
            $d /= $start_from;
        }
        $Cache{$n} = 1 + num_distinct_factors( $d, $start_from + 1 );
    }
    return $Cache{$n};
}

my @primes;
my $__primes_fh;
open $__primes_fh, "primes 2|";
my $primes_buf = "";

sub inc_prime
{
    my $idx = shift;

    if ( $idx > $#primes )
    {
        read( $__primes_fh, $primes_buf, 4096, length($primes_buf) );
        push @primes, split( /\n/, $primes_buf, -1 );
        $primes_buf = pop(@primes);
    }
}

use vars qw($n);
$n = 1;

# p, q, r, s
for my $s ( 3 .. 1_000_000_000 )
{
    inc_prime($s);
    local $n = $n * $primes[$s];
    for my $r ( 2 .. $s - 1 )
    {
        local $n = $n * $primes[$r];
        for my $q ( 1 .. $r - 1 )
        {
            local $n = $n * $primes[$q];
            for my $p ( 0 .. $q - 1 )
            {
                local $n = $n * $primes[$p];

                for my $check ( $n - 3 .. $n )
                {
                    if (
                        all { num_distinct_factors( $_, 2 ) == 4 }
                        ( $check .. $check + 3 )
                        )
                    {
                        print "Found $check\n";
                    }
                }
            }
        }
    }
}

