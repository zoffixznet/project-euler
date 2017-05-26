#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw/ max min /;

my $NUM_DIGITS = shift @ARGV;

my %p;
my @primes = `primes 2 1@{[0 x $NUM_DIGITS]}`;
chomp @primes;
@p{@primes} = ();

$p{2} = 2;

my @q = (2);

my $cnt = 0;
while ( defined( my $i = shift @q ) )
{
    if ( ++$cnt % 10_000 == 0 )
    {
        print "Reached $cnt [queued : @{[scalar@q]}]\n";
    }
    my $l   = length $i;
    my $v   = $p{$i};
    my $try = sub {
        my $new = shift;
        if ( exists( $p{$new} ) )
        {
            if ( !defined $p{$new} )
            {
                $p{$new} = max( $new, $v );
                push @q, $new;
            }
            else
            {
                my $old_v = $p{$new};
                if ( $old_v > ( $p{$new} = min( max( $new, $v ), $old_v ) ) )
                {
                    push @q, $new;
                }
            }
        }
        return;
    };
    if ( $l > 1 )
    {
        $try->( substr( $i, 1 ) );
    }
    if ( $l < $NUM_DIGITS )
    {
        for my $d ( 1 .. 9 )
        {
            $try->( $d . $i );
        }
    }
    for my $p ( 0 .. $l - 1 )
    {
        my $new = $i;
        for my $d ( 1 .. 9, ( $p ? (0) : () ) )
        {
            substr( $new, $p, 1, $d );
            if ( $new ne $i )
            {
                $try->($new);
            }
        }
    }
}

my $s = 0;
while ( my ( $i, $v ) = each %p )
{
    if ( !defined($v) or ( $v > $i ) )
    {
        print "Found $i\n";
        $s += $i;
    }
}
print "Result = $s\n";
