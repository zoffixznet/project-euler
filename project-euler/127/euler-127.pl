#!/usr/bin/perl

use strict;
use warnings;

=head1 ANALYSIS

If C< rad(c) = c > then C< rad(abc) > c >. As a result C< rad(c) < c >.
Likewise for C< rad(b) < b >.
=cut

use List::Util qw(max min reduce);
use List::MoreUtils qw(uniq);

use integer;

# $n must be > $m
sub gcd
{
    my ( $n, $m ) = @_;

    if ( $m == 0 )
    {
        return $n;
    }

    return gcd( $m, $n % $m );
}

my $cache_fn = 'rad-cache.txt';
if ( !-e $cache_fn )
{
    system("$^X gen-cache.pl > $cache_fn");
}

open my $fh, '<', $cache_fn;
my @rad_cache = map { int($_) } <$fh>;
close($fh);

my @reverse_rad;

foreach my $n ( 1 .. $#rad_cache )
{
    push @{ $reverse_rad[ $rad_cache[$n] ] }, $n;
}

# my %C_blacklist = ();

my $limit = 120_000;

# my $limit = 1_000;

my $below_limit = $limit - 1;

my $sum_C = 0;
C_loop:
for my $C ( 2 .. $below_limit )
{
    # print "C = $C\n";
    my $half_C = ( $C >> 1 );
    my $rad_C  = $rad_cache[$C];

    # rad(abc) >= 2*rad(B).
    # B = C-A > rad(abc)-A > 2*rad(B)-A
    # B+A > 2*rad(B)
    # 2 * B > B+A > 2 * rad(B)
    if ( $rad_C >= $half_C )
    {
        next C_loop;
    }
    my $div = $C / $rad_C;
    for my $rad_A ( 1 .. $div )
    {
    A_loop:
        for my $A ( @{ $reverse_rad[$rad_A] } )
        {
            if ( $A >= $half_C )
            {
                last A_loop;
            }
            my $B = $C - $A;

            if ( gcd( $B, $A ) == 1 )
            {
                if (    # gcd($C, $A) == 1 and gcd($C, $B) == 1 and
                    ( $rad_A * $rad_cache[$B] ) < $div
                    )
                {
                    print "Found $C\n";
                    $sum_C += $C;
                }
            }
        }
    }
}
print "Sum = $sum_C\n";
