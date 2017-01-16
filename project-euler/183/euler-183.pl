#!/usr/bin/perl

use strict;
use warnings;

# use integer;
use bytes;

# use Math::BigInt lib => 'GMP';
# use Math::BigRat lib => 'GMP';
#
# use Math::GMPq qw(:mpq);

use List::Util qw(sum);
use List::MoreUtils qw();
use List::UtilsBy qw(max_by);

STDOUT->autoflush(1);

my $MAX = shift(@ARGV) // 10_000;

my $sum = 0;

sub gcd
{
    my ( $n, $m ) = @_;

    if ( $n < $m )
    {
        return gcd( $m, $n );
    }

    if ( $m == 0 )
    {
        return $n;
    }

    return gcd( $m, $n % $m );
}

=begin foo

sub _exp
{
    my ($q, $e) = @_;

    if ($e == 0)
    {
        my $one = Rmpq_init;
        Rmpq_set_str($one, "1/1", 10);
        return $one;
    }
    my $rec = $e >> 1;
    my $d = _exp($q, $rec);
    $d = $d * $d;
    if ($e & 0x1)
    {
        $d *= $q;
    }

    return $d;
}

=end foo

=cut

for my $N ( 5 .. $MAX )
{
    if ( $N % 100 == 0 )
    {
        print "N=$N\n";
    }

=begin foo

    my $k = 1;
    my $max_q = Rmpq_init();
    Rmpq_set_str($max_q, "$N/1", 10);
    for my $i (2 .. $N-1)
    {
        my $q = Rmpq_init();
        Rmpq_set_str($q, "$N/$i", 10);
        my $prod = _exp($q, $i);

        if (Rmpq_cmp($prod, $max_q) > 0)
        {
            $max_q = $prod;
            $k = $i;
        }
    }

=end foo

=cut

    my $logN = log($N);
    my $k = max_by { $_ * ( $logN - log($_) ) } ( 1 .. ( $N - 1 ) );

    # M($N) == ($N/$k) ** $k
    my $g = gcd( $N, $k );

    my $k_to_check = $k / $g;

    while ( $k_to_check % 5 == 0 )
    {
        $k_to_check /= 5;
    }

    while ( ( $k_to_check & 0x1 ) == 0 )
    {
        $k_to_check >>= 1;
    }

    my $diff = ( ( $k_to_check == 1 ) ? ( -$N ) : $N );

    # print "N=$N ; Diff=$diff ; k_to_check=$k_to_check\n";
    $sum += $diff;
}

print "Sum = $sum\n";
