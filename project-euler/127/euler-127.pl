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
    my ($n, $m) = @_;

    if ($m == 0)
    {
        return $n;
    }

    return gcd($m,$n % $m);
}

my $cache_fn = 'rad-cache.txt';
if (! -e $cache_fn)
{
    system("$^X gen-cache.pl > $cache_fn");
}

open my $fh, '<', $cache_fn;
my @rad_cache = map { int($_) } <$fh>;
close($fh);

# my %C_blacklist = ();

my $limit = 120_000;

my $below_limit = $limit-1;

my $sum_C = 0;
B_loop:
for my $B (2 .. $below_limit)
{
    # print "B = $B\n";
    my $rad_B = $rad_cache[$B];

    # rad(abc) >= 2*rad(B).
    # B = C-A > rad(abc)-A > 2*rad(B)-A
    # B+A > 2*rad(B)
    # 2 * B > B+A > 2 * rad(B)
    if ($rad_B == $B)
    {
        next B_loop;
    }
    # rad(A) is at the minimum 1 and since a,b,c are stranger numbers,
    # then C > rad(abc) >= 2*rad(ab) >= 2*rad_B
    # A = C-B >= 2 * rad_B - B
    for my $A
    (
        max(2*$rad_B-$B, 1)
        ..
        min($B-1, $below_limit-$B)
    )
    {
        if (gcd($B, $A) == 1)
        {
            my $C = $A + $B;

            #if (!exists($C_blacklist{$C}))
            #{
            #    $C_blacklist{$C} = (radical($C) * 2 >= $C);
            #}

            #if (!$C_blacklist{$C})
            {
                # Since gcd(A,B) = 1 then gcd(A+B,A) and gcd(A+B,B) must be 1
                # as well.
                if ( # gcd($C, $A) == 1 and gcd($C, $B) == 1 and 
                    ($rad_cache[$A]*$rad_B*$rad_cache[$C]) < $C)
                {
                    print "Found $C\n";
                    $sum_C += $C;
                }
            }
        }
    }
}
print "Sum = $sum_C\n";
