#!/usr/bin/perl

use strict;
use warnings;

# use integer;
use bytes;

# use Math::BigInt lib => 'GMP';

use List::Util qw(min max sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $NUM_PRIMES = shift(@ARGV);

# my @primes = map { 0 + $_ } `primes 2 100`;
#
my @primes = ( 1 .. $NUM_PRIMES );

my $total = 0;

my $MAX_C     = ( 1 << 25 );
my $ITER      = 1_000;
my $count     = 0;
my $next_iter = $ITER;

my %gross_sizes;

sub f
{
    # $i is index to start from.
    # $c is count.
    my ( $i, $c ) = @_;

    if ( $i == @primes )
    {
        if ( @$c >= 4 )
        {
            $gross_sizes{"@$c"} = 1;

=begin removed.
            if (@$c > 4)
            {
                for my $pos (0 .. $#$c)
                {
                    my @link = @$c;
                    splice(@link, $pos, 1);
                    push @{$links{"@link"}}, $c;
                }
            }
=end removed

=cut

        }
    }
    else
    {
        f( $i + 1, $c );
        f( $i + 1, [ @$c, $i ] );
    }
    return;
}

f( 0, [] );

my %net_sizes;

sub calc_links
{
    my ( $c, $s ) = @_;

    my @ret;

    for my $in ( -1 .. $#$c )
    {
        for my $add ( ( ( $in == -1 ? -1 : $c->[$in] ) + 1 )
            .. ( ( $in == $#$c ? scalar(@primes) : $c->[ $in + 1 ] ) - 1 ) )
        {
            my @new = ( @$c[ 0 .. $in ], $add, @$c[ $in + 1 .. $#$c ] );
            my $n = "@new";
            if ( exists $gross_sizes{$n} )
            {
                push @ret, [ ( \@new ), $n ];
            }
        }
    }

    return \@ret;
}

sub n
{
    my ( $c, $s, $sign ) = @_;

    printf "%s {%d}[%s]\n", ( ( $sign > 0 ? '+' : '-' ), scalar(@$c), $s );

    return sub {
        my @Q = @{ calc_links( $c, $s ) };
        my %seen = ( map { +( $_->[1] => undef() ) } @Q );
        while ( defined( my $krec = shift(@Q) ) )
        {
            my ( $k, $ks ) = @$krec;
            n( $k, $ks, -$sign );

            for my $next_k ( @{ calc_links( $k, $ks ) } )
            {
                my $n_s = $next_k->[1];
                if ( !exists( $seen{$n_s} ) )
                {
                    $seen{$n_s} = undef();
                    push @Q, $next_k;
                }
            }
        }

        # $total += $size;
        return 1;
        }
        ->();
}

my $LIM = keys(%gross_sizes);
$count = 0;
foreach my $k ( keys(%gross_sizes) )
{
    # printf "Inspecting %d/%d\n", ($count++, $LIM);
    my @x = split / /, $k;
    if (1)    # if (@x == 4)
    {
        n( \@x, $k, 1 );
    }
}

# Got 77579 for $L = 1_000_000;
# Should be 77579.
# Yay!
# print "total = $total\n";
