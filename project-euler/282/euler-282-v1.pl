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
        my $x = 5 % $MOD;
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
            NEW_MOD => @seq - $NEW_PREFIX,
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

            print "MOD,PREFIX ( n = $n ) = $MOD,$PREFIX\n";
            my $CACHE_RET = get_cache({ MOD => $MOD});

            my $NEW_PREFIX = $CACHE_RET->{NEW_PREFIX};
            my $NEW_MOD = $CACHE_RET->{NEW_MOD};
            my $seq = $CACHE_RET->{seq};

            if (($NEW_PREFIX == 0) and ($NEW_MOD == 1))
            {
                print "Seq  = [@$seq]\n";
                return $seq->[0];
            }

            my $ret = A_m_is_4_mod({'m' => $m, 'n' => ($n-1), MOD => $NEW_MOD, PREFIX => $NEW_PREFIX});

            # my $r = $cache{$ret};
            my $r = $seq->[$ret];

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

    if ($ret < 0 or (!defined $ret))
    {
        die "A_m_is_4_mod($m,$n)!";
    }

    # print "A($m,$n) = $ret\n";

    return $ret;
}

my %A_m_is_5_mod__caches;

sub get__m_is_5__cache
{
    my $args = shift;

    my $MOD = $args->{'MOD'};

    return $A_m_is_5_mod__caches{$MOD} //= sub {
        my $x = A_m_is_4_mod({m => 4, n => 1, MOD => $MOD, PREFIX => 0}) % $MOD;
        my @seq = ($x);
        my %cache = ($x => $#seq);

        $x = A_m_is_4_mod({m => 4, n => $x, MOD => $MOD, PREFIX => 0});

        while (!exists($cache{$x}))
        {
            push @seq, $x;
            $cache{$x} = $#seq;
        }
        continue
        {
            $x = A_m_is_4_mod({m => 4, n => $x, MOD => $MOD, PREFIX => 0});
        }

        my $NEW_PREFIX = $cache{$x};
        return +{
            NEW_PREFIX => $NEW_PREFIX,
            NEW_MOD => @seq - $NEW_PREFIX,
            seq => \@seq,
        };
    }->();
}

sub A_m_is_5_mod
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
        elsif ($m == 4)
        {
            return A_m_is_4_mod($args);
        }
        elsif ($n == 0)
        {
            my %pass = %$args;
            $pass{'m'}--;
            $pass{'n'} = 1;
            return A_m_is_4_mod(\%pass);
        }
        elsif ($m == 5)
        {
            my $MOD = $args->{'MOD'};
            my $PREFIX = $args->{'PREFIX'};

            my $CACHE_RET = get__m_is_5__cache({ MOD => $MOD});

            my $NEW_PREFIX = $CACHE_RET->{NEW_PREFIX};
            my $NEW_MOD = $CACHE_RET->{NEW_MOD};
            my $seq = $CACHE_RET->{seq};

            if (($NEW_PREFIX == 0) and ($NEW_MOD == 1))
            {
                print "Seq{5}  = [@$seq]\n";
                return $seq->[0];
            }

            my $ret = A_m_is_5_mod({'m' => $m, 'n' => ($n-1), MOD => $NEW_MOD, PREFIX => $NEW_PREFIX});

            # my $r = $cache{$ret};
            my $r = $seq->[$ret];

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

    if ($ret < 0 or (!defined $ret))
    {
        die "A_m_is_5_mod($m,$n)!";
    }

    # print "A($m,$n) = $ret\n";

    return $ret;
}

my %A_m_is_6_mod__caches;

sub get__m_is_6__cache
{
    my $args = shift;

    my $MOD = $args->{'MOD'};

    return $A_m_is_6_mod__caches{$MOD} //= sub {
        my $x = A_m_is_5_mod({m => 5, n => 1, MOD => $MOD, PREFIX => 0}) % $MOD;
        my @seq = ($x);
        my %cache = ($x => $#seq);

        $x = A_m_is_5_mod({m => 5, n => $x, MOD => $MOD, PREFIX => 0});

        while (!exists($cache{$x}))
        {
            push @seq, $x;
            $cache{$x} = $#seq;
        }
        continue
        {
            $x = A_m_is_5_mod({m => 5, n => $x, MOD => $MOD, PREFIX => 0});
        }

        my $NEW_PREFIX = $cache{$x};
        return +{
            NEW_PREFIX => $NEW_PREFIX,
            NEW_MOD => @seq - $NEW_PREFIX,
            seq => \@seq,
        };
    }->();
}

sub A_m_is_6_mod
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
        elsif ($m <= 5)
        {
            return A_m_is_5_mod($args);
        }
        elsif ($n == 0)
        {
            my %pass = %$args;
            $pass{'m'}--;
            $pass{'n'} = 1;
            return A_m_is_5_mod(\%pass);
        }
        elsif ($m == 6)
        {
            my $MOD = $args->{'MOD'};
            my $PREFIX = $args->{'PREFIX'};

            my $CACHE_RET = get__m_is_6__cache({ MOD => $MOD});
            my $ret = A_m_is_6_mod({'m' => $m, 'n' => ($n-1), MOD => $CACHE_RET->{NEW_MOD}, PREFIX => $CACHE_RET->{NEW_PREFIX}});

            # my $r = $cache{$ret};
            my $r = $CACHE_RET->{seq}->[$ret];

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

    if ($ret < 0 or (!defined $ret))
    {
        die "A_m_is_6_mod($m,$n)!";
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

for my $m (5)
{
    for my $n (0 .. 0)
    {
        print "A($m,$n) = ", (A($m,$n) % $ULTIMATE_MOD), "\n";
    }
}

for my $m (5)
{
    for my $n (0 .. 5)
    {
        print "A_mod($m,$n) = ", A_m_is_5_mod({m => $m, n => $n, MOD => $ULTIMATE_MOD, PREFIX => 0,}), "\n";
    }
}

for my $m (6)
{
    for my $n (0 .. 6)
    {
        print "A_mod($m,$n) = ", A_m_is_6_mod({m => $m, n => $n, MOD => $ULTIMATE_MOD, PREFIX => 0,}), "\n";
    }
}
