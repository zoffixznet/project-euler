#!/usr/bin/perl

use strict;
use warnings;

use List::MoreUtils qw(all);

=head1 DESCRIPTION

Using all of the digits 1 through 9 and concatenating them freely to form
decimal integers, different sets can be formed. Interestingly with the set
{2,5,47,89,631}, all of the elements belonging to it are prime.

How many distinct sets containing each of the digits one through nine exactly
once contain only prime elements?

=cut

sub is_prime
{
    my $n = shift;

    return all { $n % $_ } (2 .. int(sqrt($n)));
}

# print "is_prime(2963) = ", is_prime(2963), "\n";
# print "is_prime(2962) = ", is_prime(2962), "\n";

my @sets_by_rank;

push @sets_by_rank, undef();
push @sets_by_rank, 
    { 
        map { 
            my $p = $_;
            my $s = '';
            vec($s, $p, 1) = 1;
            # count and made of.
            $s => { c => 1, m => [{ n => $p },],};
        } qw(2 3 5 7),
    };

foreach my $rank (2 .. 8)
{
    # Configure 
}
