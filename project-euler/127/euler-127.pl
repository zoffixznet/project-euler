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

sub gcd
{
    my ($n, $m) = @_;

    if ($n < $m)
    {
        return gcd($m,$n);
    }

    if ($m == 0)
    {
        return $n;
    }

    return gcd($m,$n % $m);
}

$a = $b = 0;

sub radical
{
    my $n = shift;
    my $factors = `factor $n`;
    $factors =~ s{\A[^:]+:}{};
    return reduce { $a * $b } 1, uniq($factors =~ m/(\d+)/g);
}

my %C_s = ();

my %C_blacklist = ();

my $limit = 1_000;

my $below_limit = $limit-1;
B_loop:
for my $B (3 .. $below_limit)
{
    print "B = $B\n";
    my $rad_B = radical($B);

    # rad(abc) >= 6*rad(B).
    # B = C-A > rad(abc)-A > 6*rad(B)-A
    # B+A > 6*rad(B)
    # 2 * B > B+A > 6 * rad(B)
    if ($rad_B * 3 >= $B)
    {
        next B_loop;
    }
    # rad(A) is at the minimum 2 and since a,b,c are stranger numbers,
    # then C > rad(abc) >= 2*rad(ab) >= 6*rad_B
    # A = C-B >= 6 * rad_B - B
    for my $A
    (
        max(6*$rad_B-$B, 2)
        ..
        min($B-1, $below_limit-$B)
    )
    {
        if (gcd($B, $A) == 1)
        {
            my $C = $A + $B;

            if (!exists($C_blacklist{$C}))
            {
                $C_blacklist{$C} = (radical($C) * 6 >= $C);
            }

            if (!$C_blacklist{$C})
            {
                # Since gcd(A,B) = 1 then gcd(A+B,A) and gcd(A+B,B) must be one
                # as well.
                if ( # gcd($C, $A) == 1 and gcd($C, $B) == 1 and 
                    radical($A*$B*$C) < $C)
                {
                    print "Found $C\n";
                    $C_s{$C} = $C_blacklist{$C} = 1;
                }
            }
        }
    }
}
