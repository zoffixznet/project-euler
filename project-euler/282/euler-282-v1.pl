#!/usr/bin/perl

use strict;
use warnings;

no warnings 'recursion';

use Math::GMP;

use integer;
use bytes;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

# The cache.
my %c;

sub A
{
    my ($m, $n) = @_;

    my $ret = sub {
        if ($m == 0)
        {
            return Math::GMP->new("$n")+1;
        }
        elsif ($m == 1)
        {
            return Math::GMP->new("$n")+2;
        }
        elsif ($m == 2)
        {
            return ((Math::GMP->new("$n")<<1)+3);
        }
        elsif ($m == 3)
        {
            return ((Math::GMP->new('1') << (Math::GMP->new("$n") + 3)) - 3);
        }
        elsif ($n == 0)
        {
            return A($m-1,1);
        }
        else
        {
            return $c{"$m"}{"$n"} //= A($m-1, A($m,$n-1));
        }
    }->();

    if ($ret <= 0)
    {
        die "A($m,$n)!";
    }

    # print "A($m,$n) = $ret\n";

    return $ret;
}

my $ULTIMATE_MOD = 14 ** 8;

my %A_m_is_4_mod__caches;

sub get_cache
{
    my $args = shift;

    my $MOD = $args->{'MOD'};

    return $A_m_is_4_mod__caches{$MOD} //= sub {
        my $x = 1;
        my @seq = ($x);
        my %cache = ($x => $#seq);

        $x = ((($x << 1) + 3) % $MOD);

        while (!exists($cache{$x}))
        {
            push @seq, $x;
            $cache{$x} = $#seq;
        }
        continue
        {
            $x = ((($x << 1) + 3) % $MOD);
        }

        my $NEW_PREFIX = $cache{$x};
        return +{
            NEW_PREFIX => $NEW_PREFIX,
            NEW_MOD => $#seq - $NEW_PREFIX,
            seq => \@seq,
        };
    }->();
}

sub A_m_is_4_mod
{
    my $args = shift;

    my $m = $args->{'m'};
    my $n = $args->{'n'};

    my $ret = sub {
        if ($m == 0)
        {
            return Math::GMP->new("$n")+1;
        }
        elsif ($m == 1)
        {
            return Math::GMP->new("$n")+2;
        }
        elsif ($m == 2)
        {
            return ((Math::GMP->new("$n")<<1)+3);
        }
        elsif ($m == 3)
        {
            return ((Math::GMP->new('1') << (Math::GMP->new("$n") + 3)) - 3);
        }
        elsif ($n == 0)
        {
            return A($m-1,1);
        }
        elsif ($m == 4)
        {
            my $MOD = $args->{'MOD'};
            my $PREFIX = $args->{'PREFIX'};

            my $CACHE_RET = get_cache({ MOD => $MOD});
            my $ret = A_m_is_4_mod({'m' => $m, 'n' => ($n-1), MOD => $CACHE_RET->{NEW_MOD}, PREFIX => $CACHE_RET->{NEW_PREFIX}});

            # my $r = $cache{$ret};
            my $r = $CACHE_RET->{seq}->[$ret+1];

            if ($r < $PREFIX)
            {
                return $r;
            }
            else
            {
                return (($r - $PREFIX) % $MOD + $PREFIX);
            }
        }
        else
        {
            return $c{"$m"}{"$n"} //= A($m-1, A($m,$n-1));
        }
    }->();

    if ($ret <= 0)
    {
        die "A_m_is_4_mod($m,$n)!";
    }

    # print "A($m,$n) = $ret\n";

    return $ret;
}

for my $m (0 .. 3)
{
    for my $n (0 .. 100)
    {
        print "A($m,$n) = ", A($m,$n), "\n";
    }
}

for my $m (4)
{
    for my $n (0 .. 2)
    {
        print "A($m,$n) = ", (A($m,$n) % $ULTIMATE_MOD), "\n";
    }
}

for my $m (4)
{
    for my $n (0 .. 4)
    {
        print "A_mod($m,$n) = ", A_m_is_4_mod({m => $m, n => $n, MOD => $ULTIMATE_MOD, PREFIX => 0,}), "\n";
    }
}
