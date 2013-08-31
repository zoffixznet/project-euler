#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt (only => 'GMP', ':constant');
use List::Util qw(sum);
use List::MoreUtils qw(all);

sub is_prime
{
    my ($n) = @_;

    if ($n <= 1)
    {
        return 0;
    }

    my $top = int(sqrt($n));

    for my $i (2 .. $top)
    {
        if ($n % $i == 0)
        {
            return 0;
        }
    }

    return 1;
}

my $MIN = 2;
my $MAX = 80;

my (@keys, $lcm, @ints, $target);

my @primes = (grep { is_prime($_) } (3 .. $MAX));
my %primes_lookup = (map { $_ => 1 } @primes);

my @init_to_check = (grep { (!(exists($primes_lookup{$_}) || ((($_&0x1) == 0) && exists($primes_lookup{$_>>1})))) || $_ < $MAX/3 } ($MIN .. $MAX));

@keys = @init_to_check;

sub calc_stuff
{
    $lcm = Math::BigInt::blcm(map { $_ * $_ } @keys);

    @ints = (map { $lcm / ($_ * $_) } @keys);

    $target = $lcm / 2;

    return;
}

calc_stuff();

=begin Removed

# Deduced by semi-manual deduction.
@keys = @keys[grep { $ints[$_] % 100 == 0 } keys(@keys)];
calc_stuff();

# Deduced by semi-manual deduction.
@keys = @keys[grep { $ints[$_] % 2 == 0 } keys(@keys)];
calc_stuff();

# Deduced by semi-manual deduction.
@keys = @keys[grep { $ints[$_] % 7 == 0 } keys(@keys)];
calc_stuff();

# Deduced by semi-manual deduction.
@keys = @keys[grep { $ints[$_] % 9 == 0 } keys(@keys)];
calc_stuff();

# Deduced by semi-manual deduction.
@keys = @keys[grep { $ints[$_] % 15 != 1 } keys(@keys)];
calc_stuff();

# Deduced by semi-manual deduction.
@keys = @keys[grep { $ints[$_] % 4 == 0 } keys(@keys)];
calc_stuff();

# Deduced by semi-manual deduction.
@keys = @keys[grep { $ints[$_] % 17 != 15 } keys(@keys)];
calc_stuff();

=end Removed

=cut

my @must_have = (2,3,4,5,6,7,9,10,12,15,20,28,30,35,36,45);

my %must_have_lookup = (map { $_ => 1 } @must_have);

my $found = 1;
MAIN_TRIM:
while ($found)
{
    $found = 0;

    if (@keys == 41)
    {
        # last MAIN_TRIM;
    }

    TRIM_STUFF:
    for my $n ($MIN .. 1000)
    {
        print "N == $n ; NumKeys == ", scalar(@keys), "\n";

        # mod is modulo
        my %mods_hash;
        foreach my $mod (grep { $_ } map { $_ % $n } @ints)
        {
            $mods_hash{"$mod"} ||= {count => 0, can_be_formed => 0,};
            $mods_hash{"$mod"}{count}++;
        }
        my %agg_mods;

        foreach my $mod (keys(%mods_hash))
        {
            foreach my $c (1 .. $mods_hash{$mod}{count})
            {
                my $agg_mod = (($mod*$c) % $n);
                $agg_mods{$agg_mod} ||= {};
                $agg_mods{$agg_mod}{$mod} = 1;
            }
        }
        my $target_mod = $lcm % $n;

        my @mods = sort { $a <=> $b } keys(%agg_mods);

        if ((@mods == $n) || (@mods == $n-1) ||
            ($n == 31 and @keys == 41) ||
            ($n == 38 and @keys == 41) ||
            (all { exists($agg_mods{$n-$_}) } @mods ) ||
            (
                (all { exists($agg_mods{$_}) } (1 .. 3))
                    and
                (all { $mods[$_+1] - $mods[$_] <= 3 } (0 .. $#mods-1))
                    and
                ($mods[-1] >= $n-3)
            )
                or
            (@mods > 15)
        )
        {
            next TRIM_STUFF;
        }
        my $count_not_found_yet = 0+scalar(keys(%mods_hash));
        foreach my $combo (1 .. ((1 << @mods)-1))
        {
            my @indexes = grep { (($combo >> $_) & 0x1) } keys(@mods);
            if (sum (@mods[@indexes]) % $n == $target_mod)
            {
                foreach my $agg_m (@mods[@indexes])
                {
                    foreach my $m (keys(%{$agg_mods{$agg_m}}))
                    {
                        if (! $mods_hash{"$m"}{can_be_formed})
                        {
                            if (not --$count_not_found_yet)
                            {
                                next TRIM_STUFF;
                            }
                        }
                        $mods_hash{"$m"}{can_be_formed} = 1;
                    }
                }
            }
        }

        my @not_included_mods =
        (grep { ! $mods_hash{"$_"}{can_be_formed} } keys(%mods_hash));

        if (@not_included_mods)
        {
            print "Found [@not_included_mods] for Modulo == $n!\n";
            $found = 1;
            my %not_mods = (map { $_.'' => 1 } (@not_included_mods));
            @keys = @keys[
                (grep { !exists($not_mods{($ints[$_] % $n).''}) } keys(@keys))
            ];
            # Sanity check for keys that must be present.
            if ((grep { exists($must_have_lookup{$_}) } @keys) !=
                scalar(keys %must_have_lookup))
            {
                die "Some keys are missing.";
            }
            last TRIM_STUFF;
        }
    }

    if ($found)
    {
        calc_stuff();
    }
}

print join("\n", map { "$keys[$_] => $ints[$_]" } keys(@keys)), "\n";

print "TARGET ==\n$target\n";
