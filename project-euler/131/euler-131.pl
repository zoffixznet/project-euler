#!/usr/bin/perl

use strict;
use warnings;

use IO::Handle;

STDOUT->autoflush(1);
use Math::BigInt lib => 'GMP', ':constant';

=head1 ANALYSIS

n^3+n^2*p = n^2(n+p).

Can n > p? The number is n^2(n+p), where n+p is co-prime to n (WRONG! n
may be divisible by p). So n^2 must
be a perfect cube and so does n+p. In order for n^2 to be a cube, so does n.
The difference between two cubes is:
a^3 – b^3 = (a – b)(a^2 + ab + b^2), so it can be prime only if
a - b = 1 . Ergo: n <= p.

n != p because otherwise the number will be 2n^3 which cannot be a cube.
So n < p.

=cut

open my $primes_fh, '-|', 'primes', '2', '1000000'
    or die "Cannot open primes program!";

my @primes = <$primes_fh>;

close($primes_fh);

chomp(@primes);

my %primes_map;
@primes_map{@primes} = ( (1) x @primes );

my $root        = 1;
my $total_count = 0;

ROOTS:
while (1)
{
    my $to_check = (
        $root * $root + $root * ( $root + 1 ) + ( $root + 1 ) * ( $root + 1 ) );

    if ( $to_check > 1_000_000 )
    {
        last ROOTS;
    }
    if ( exists( $primes_map{"$to_check"} ) )
    {
        $total_count++;
        print "Found $to_check ; Total found = $total_count\n";
    }
    else
    {
        print "$to_check is not prime.\n";
    }
}
continue
{
    $root++;
}

__END__
my $found_count = 0;

while (my $prime = <$primes_fh>)
{
    chomp($prime);
    print "Reached $prime\n";
    N_LOOP:
    for my $n (1 .. $prime*3)
    {
        my $x = Math::BigInt->new($n*$n*($n+$prime));

        if ($x->copy->broot(3)->bpow(3) == $x)
        {
            $found_count++;
            print "Found $prime with $n. Total: $found_count\n";
            last N_LOOP;
        }
    }
}
