#!/usr/bin/perl

use strict;
use warnings;
use autodie;

use 5.016;

use integer;
use bytes;

# No :constant !
use Math::BigInt try => 'GMP';

use JSON::MaybeXS qw(decode_json encode_json);
use IO::All;

STDOUT->autoflush(1);

=head1 DESCRIPTION

Let f(n) be the largest positive integer x less than 109 such that the last 9 digits of nx form the number x (including leading zeros), or zero if no such integer exists.

For example:

    f(4) = 411728896 (4411728896 = ...490411728896)
    f(10) = 0
    f(157) = 743757 (157743757 = ...567000743757)
    Σf(n), 2 ≤ n ≤ 103 = 442530011399

Find Σf(n), 2 ≤ n ≤ 106.

=cut

use List::Util qw(reduce);

my @Cache = (undef, []);

sub factorize_helper
{
    my ($n, $start_from) = @_;

    my $limit = int(sqrt($n));

    if (! defined($Cache[$n]))
    {
        my $d = $n;
        while ($d % $start_from)
        {
            if (++$start_from > $limit)
            {
                return $Cache[$n] = [[$n,1]];
            }
        }

        $d /= $start_from;

        my @n_factors = (map { [@$_] } @{factorize_helper($d, $start_from)});

        if (@n_factors && $n_factors[0][0] == $start_from)
        {
            $n_factors[0][1]++;
        }
        else
        {
            unshift @n_factors, ([$start_from, 1]);
        }

        $Cache[$n] = \@n_factors;
    }
    return $Cache[$n];
}

sub factorize
{
    my ($n) = @_;
    return factorize_helper($n, 2);
}

my $MOD = 1_000_000_000;

# exp_mod_slow.
sub em_slow
{
    my ($b, $e) = @_;

    my $r = 1;

    for my $i (1 .. $e)
    {
        ($r *= $b) %= $MOD;
    }

    return $r;
}

sub exp_mod
{
    my ($b, $e) = @_;

    if ($e == 0)
    {
        return 1;
    }

    my $rec_p = exp_mod($b, ($e >> 1));

    my $ret = $rec_p * $rec_p;

    if ($e & 0x1)
    {
        ($ret %= $MOD) *= $b;
    }

    return ($ret % $MOD);
}

my $cycles_json_fn = 'euler-455-cycles.json';
my $cycles;

if (! -e $cycles_json_fn)
{
    my $twos_cycles = $cycles->[2] ||= {};
    my $fives_cycles = $cycles->[5] ||= [];

    foreach my $power_of_2_e (1 .. 32)
    {
        say "power_of_2_e = $power_of_2_e";
        my $power_of_2 = (1 << $power_of_2_e);

        my %found_modulos;

        my $m = $power_of_2 % $MOD;
        my $e = 1;

        while (!exists($found_modulos{$m}))
        {
            $found_modulos{$m} = $e;
            $e++;
            ($m *= $power_of_2) %= $MOD;
        }

        $twos_cycles->{($power_of_2<<1)-1} = [$power_of_2_e, $e - $found_modulos{$m}];
    }

    {
        my $power_of_5 = 5;
        while ($power_of_5 <= $MOD)
        {
            my %found_modulos;

            my $m = $power_of_5 % $MOD;
            my $e = 1;

            while (!exists($found_modulos{$m}))
            {
                $found_modulos{$m} = $e;
                $e++;
                ($m *= $power_of_5) %= $MOD;
            }

            push @$fives_cycles, [$power_of_5, $e-$found_modulos{$m}];
        }
        continue
        {
            $power_of_5 *= 5;
        }
    }

    io->file($cycles_json_fn)->utf8->print(encode_json($cycles));
}
else
{
    $cycles = decode_json(io->file($cycles_json_fn)->utf8->all());
}

my $twos_cycles = $cycles->[2];
my $fives_cycles = $cycles->[5];

my $base_cycle_len = 0 + (''. Math::BigInt::blcm(
    map { my ($p, $k) = @$_; ($p ** ($k-1)*($p-1)) / ($p == 2 ? 2 : 1) } ([2,9],[5,9])
));

# By experiment it's the only possible cycle_len.
my $CYCLE_LEN = 50_000_000;

sub calc_f
{
    my ($n) = @_;

    my $x = 0;

    if ($n % 10 != 0)
    {
=begin foo
        my $divisor_cycle_len = 1;
        my $n_dividend = $n;

        if (my $twos = $twos_cycles->{$n ^ ($n -1)})
        {
            $n_dividend = ($n >> $twos->[0]);
            $divisor_cycle_len = $twos->[1];
        }
        else
        {
            FIVES:
            foreach my $fives (@$fives_cycles)
            {
                if ($n % $fives->[0] == 0)
                {
                    $divisor_cycle_len = $fives->[1];
                    $n_dividend /= 5;
                }
                else
                {
                    last FIVES;
                }
            }
        }

        # say "N = $n ; divisor_cycle_len = $divisor_cycle_len ; N_dividend = $n_dividend";

        my $cycle_len = 0 + ('' . Math::BigInt::blcm($divisor_cycle_len, $base_cycle_len));

        say "N = $n ; cycle_len = $cycle_len ; N_dividend = $n_dividend";

        for my $i (100+$cycle_len)
        {
            if (exp_mod($n, $i) != exp_mod($n, $i+$cycle_len))
            {
                die "Wrong cycle in $n";
            }
        }
=end foo

=cut

        my $power = 1;
        for my $e (1 .. ($CYCLE_LEN << 1))
        {
            ($power *= $n) %= $MOD;
            if (($power - $e) % $CYCLE_LEN == 0
                    and $power > $x
            )
            {
                $x = $power;
            }
        }

=begin foo

        my $cache = '';

        my $e = 0;
        my $power = 1;

        # Find the first cycle len.
        while (! vec($cache, $power, 1))
        {
            vec($cache,$power, 1) = 1;
        }
        continue
        {
            $e++;
            ($power *= $n) %= $MOD;
        }

        my $found_power = $power;
        my $found_e = $e;

        $power = 1;
        $e = 0;
        while ($power != $found_power)
        {
            $e++;
            ($power *= $n) %= $MOD;
        }

        my $cycle_len = $found_e-$e;

        $power = 1;
        for my $e2 (0 .. $found_e)
        {
            if (($power - $e2) % $cycle_len == 0
                    and $power > $x
            )
            {
                $x = $power;
            }
        }
        continue
        {
            ($power *= $n) %= $MOD;
        }

=end foo

=cut

    }

    print "f($n) == $x\n";

    return $x;
}

my $MAX = 1_000_000;
my $sum = 0;

my ($START, $END) = @ARGV;

foreach my $n ($START .. $END)
{
    $sum += calc_f($n);
}

say "Sum == $sum";
