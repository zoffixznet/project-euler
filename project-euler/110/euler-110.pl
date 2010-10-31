#!/usr/bin/perl

use strict;
use warnings;

=head1 DESCRIPTION:

In the following equation x, y, and n are positive integers:

1/x + 1/y = 1/n

For n = 4 there are exactly three distinct solutions:

* 1/5 + 1/20 = 1/4

* 1/6 + 1/12 = 1/4

* 1/8 + 1/8 = 1/4

What is the least value of n for which the number of distinct solutions exceeds one-thousand?

=head1 ANALYSIS

ny + nx = xy

n (x+y) = xy

n = xy / (x+y)

x,y > n

1/y = 1/n-1/x = (x-n)/nx

y = nx/(x-n)

If t = x-n ; x = t + n

y = n*(t+n) / t = n + [ n^2 / t ]

t \in [1 .. n]

If n = p1^e1 * p2^e2 * p3^e3 ....

Then the number of t's is (2*e1+1)*(2*e2+1)*(2*e3+1)*(2*e4+1)/2

=cut


=begin Removed

use integer;

for (my $n = 1_000; ;$n++)
{
    my $count = 0;
    my $n_sq = $n * $n;

    for my $t (1 .. $n)
    {
        if (! ($n_sq % $t))
        {
            $count++;
        }
    }
    print "Reached $n [$count]\n";
    if ($count > 1_000)
    {
        print "N = $n\n";
        exit(0);
    }
}

=end Removed

=cut

use Math::GMP;

use Heap::Fibonacci;
use Heap::Elem::Num qw(NumElem);

use List::Util qw(reduce);

my $heap = Heap::Fibonacci->new;

my $limit = 4_000_000;
my $num_divisors = ($limit * 2 -1);

my $primes_list = '';

{
    open my $fh, "primes 2 |";
    for my $i (0 .. $limit)
    {
        my $p = <$fh>;
        chomp($p);
        vec($primes_list, $i, 32) = $p;
    }
    close($fh);
}

my %decomposition = ('1' => []);

$heap->add(NumElem(1));

while (my $elem = $heap->extract_top) {
    my $n = $elem->val;

    my $composition = $decomposition{"$n"};
    if ((reduce { $a * $b } 1, map { Math::GMP->new($_ * 2 + 1) } @$composition) > $num_divisors
        )
    {
        print "Found $n\n";
        exit(0);
    }
    else
    {
        foreach my $idx (
            0 
                .. 
            ((@$composition == $limit)
                ? ($#$composition)
                : ($#$composition+1)
            )
        )
        {
            my @new = @$composition;
            $new[$idx]++;
            my $new_n = 
                reduce { $a * $b } 1, 
                map { Math::GMP->new(vec($primes_list, $_, 32)) ** $new[$_] } (0 .. $#new) 
                ;
            if (! exists($decomposition{"$new_n"}))
            {
                $decomposition{"$new_n"} = \@new;
                $heap->add( NumElem($new_n) );
            }
        }
    }
}
