#!/usr/bin/perl

use strict;
use warnings;

use 5.016;

no warnings 'recursion';

use Euler_463_v2;

my $MOD = 1_000_000_000;

my $LOWER = 100;

my $UPPER = $LOWER * 2;

sub _cache
{
    my ($h, $key, $promise) = @_;

    my $ret = $h->{$key};

    if(!defined($ret))
    {
        $ret = $promise->();
    }

    my $num_keys = scalar keys %$h;

    if ($num_keys >= $UPPER)
    {
        my @to_del;

        my $NUM = $num_keys - $LOWER;
        K:
        while (my ($k, undef) = each %$h)
        {
            push @to_del, $k;
            if (@to_del == $NUM)
            {
                last K;
            }
        }
        delete @$h{@to_del};
    }
    $h->{$key} = $ret;

    return $ret;
}

my %cache;

sub f_mod
{
    my ($n) = @_;

    return _cache(\%cache, $n, sub {
        if ($n == 1)
        {
            return 1;
        }
        elsif ($n == 3)
        {
            return 3;
        }
        elsif (($n & 1) == 0)
        {
            return f_mod($n >> 1);
        }
        elsif (($n & 3) == 1)
        {
            return (2 * f_mod(($n >> 1) + 1) - f_mod($n >> 2)) % $MOD;
        }
        else
        {
            return (3 * f_mod(($n >> 1)) - 2 * f_mod($n >> 2)) % $MOD;
        }
        });
}

sub s_bruteforce
{
    my ($n) = @_;

    my $s = 0;

    foreach my $i (1 .. $n)
    {
        ($s += f_mod($i)) %= $MOD;
    }

    return $s;
}

{
    my %s_cache;

    sub s_smart
    {
        my ($start, $end) = @_;

        # say "s->e : $start->$end";
        return _cache(\%s_cache, "$start|$end", sub {
                if ($start > $end)
                {
                    return 0;
                }
                if ($start == $end)
                {
                    return f_mod($start);
                }
                if ($end <= 8)
                {
                    return s_bruteforce($end) - s_bruteforce($start - 1);
                }
                if (($start & 0b11) != 0)
                {
                    return ((f_mod($start) + s_smart($start+1, $end)) % $MOD);
                }
                if (($end & 0b11) != 0b11)
                {
                    return ((f_mod($end) + s_smart($start, $end-1)) % $MOD);
                }
                # start is a power of 2.
                if (($start & ($start - 1)) == 0)
                {
                    my $new_end = (($start << 1)-1);
                    if ($new_end <= $end)
                    {
                        my @c = Euler_463_v2->new->lookup($start);
                        return (($c[0] * f_mod(3) + $c[1] * f_mod(1) + s_smart($new_end+1, $end)) % $MOD);
                    }
                }
                else
                {
                    my $power2 = ((($start-1)^$start)+1);
                    my $new_end = $start + $power2 - 1;
                    while ($new_end > $end)
                    {
                        $power2 >>= 1;
                        $new_end = $start + $power2 - 1;
                    }
                    my @c = Euler_463_v2->new->lookup($power2);
                    my $m = $start / $power2;
                    return (($c[0] * f_mod($m*2+1) + $c[1] * f_mod($m) + s_smart($new_end+1, $end)) % $MOD);
                }
            },
        );
    }
}

if (1)
{
    my $want = 0;
    foreach my $n (1 .. 1_000_000)
    {
        ($want += f_mod($n)) %= $MOD;
        my $have = s_smart(1, $n);
        if ($want != $have)
        {
            die "want=$want have=$have n=$n!";
        }
    }
}

{
    say "S(3 ** 37) = ", s_smart(1, (eval join'*',(3) x 37));
}
