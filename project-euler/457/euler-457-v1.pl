#!/usr/bin/perl

use strict;
use warnings;

STDOUT->autoflush(1);

my $LIM = 10_000_000;

my $sum = 0;

my %mod5_blacklist = ( map { $_ => 1 } ( 0, 1, 4 ) );

# Filter out all the primes whose modulo with 3 is 2, because they cannot
# match both expressions based on modulo analysis for that modulo.
my $primes_sqs = [
    map { $_ * $_ }
        grep {
        not( ( $_ % 3 == 2 ) || ( exists( $mod5_blacklist{ $_ % 5 } ) ) )
        } `primes 2 $LIM`
];

my $n = 1;
while ( @$primes_sqs > 0 )
{
    my $next_primes_sqs = [];
    my $f_n = $n * ( $n - 3 ) - 1;

    my $count = @$primes_sqs;

    foreach my $p_sq (@$primes_sqs)
    {
        if ( $f_n % $p_sq == 0 )
        {
            print "Found R(", sqrt($p_sq), ") == $n\n";
            print "Remaining: ", ( --$count ), "\n";
            $sum += $n;
        }
        else
        {
            push @$next_primes_sqs, $p_sq;
        }
    }

    $primes_sqs = $next_primes_sqs;
    $n++;
}

print "Sum == $sum\n";
