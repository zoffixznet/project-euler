use strict;
use warnings;
use integer;
use 5.016;
no warnings 'recursion';

use Math::GMP ();

my $BASE = 14;
my $MAX  = 10000;

# $MAX = 9;

my @MP;

my $ret = Math::GMP->new(0);

sub rec
{
    my ( $n, $sq, $is_z, $digits_sum ) = @_;

    if ( $n > $MAX )
    {
        return;
    }
    my $M = $MP[$n];
    if ( ( ( $sq * $sq ) % $M->[1] ) != $sq )
    {
        return;
    }
    if ( $sq == 0 and $n > 3 )
    {
        return;
    }
    if ( !$is_z )
    {
        $ret += $digits_sum;
    }
    for my $d ( 0 .. $BASE - 1 )
    {
        rec( $n + 1, $sq + $M->[$d], ( scalar( $d == 0 ) ), $digits_sum + $d );
    }
    return;
}

push @MP, [ map { Math::GMP->new($_) } 0 .. $BASE - 1 ];
for my $n ( 1 .. $MAX + 1 )
{
    push @MP, [ map { $MP[-1][1] * $_ * $BASE } 0 .. $BASE - 1 ];
}
rec( 0, 0, 1, 0 );

sub base14
{
    my ($n) = @_;
    if ( $n == 0 )
    {
        return '';
    }
    else
    {
        return base14( $n / $BASE ) . sprintf( "%x", $n % $BASE );
    }
}
say base14($ret);
