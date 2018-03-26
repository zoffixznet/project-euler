#!/usr/bin/perl

use strict;
use warnings;
use integer;
use bigint;

sub divisors
{
    local $_ = shift;
    s/\A([0-9]+):\s*//;
    my $n = $1;
    my %f;
    foreach my $f ( split /\s+/, $_ )
    {
        die if $f !~ /\S/;
        $f{$f}++;
    }

    my @t;
    while ( my ( $k, $v ) = each %f )
    {
        push @t, [ $k => $v ];
    }
    return f(@t);
}

sub f
{
    if ( !@_ )
    {
        return (1);
    }
    else
    {
        my ( $f, $m ) = @{ shift(@_) };
        my @r = f(@_);

        my $x = 1;
        my @ret;
        for my $e ( 0 .. $m )
        {
            push @ret, map { $x * $_ } @r;
        }
        continue
        {
            $x *= $f;
        }
        return @ret;
    }
}

sub t_div
{
    my $n = shift;

    return +{ map { $_ => 1 } divisors( scalar `factor "$n"` ) };
}

my $N = ( 1 << 60 ) - 1;
my @S = map { ( 1 << $_ ) - 1 } grep { 60 % $_ == 0 } 1 .. 59;

my $NN = t_div($N);
foreach my $h ( map { t_div($_) } @S )
{
    delete @{$NN}{ keys %$h };
}

my $sum = 0;
foreach my $k ( keys %$NN )
{
    $sum += $k + 1;
}
print "sum = $sum\n";
