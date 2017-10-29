#!/usr/bin/perl

use strict;
use warnings;

use Algorithm::Permute ();

my $count = 0;
my $N     = shift @ARGV;
my $p     = Algorithm::Permute->new( [ 0 .. ( $N - 1 ) ] );
while ( my @res = $p->next )
{
    ++$count if not grep { $res[$_] == $_ } keys @res;
}
print "$N\t$count\n";
