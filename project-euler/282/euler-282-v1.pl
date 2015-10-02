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

my @m_cache;

sub get__m__cache
{
    my $args = shift;

    my $MOD = $args->{'MOD'};
    my $m = $args->{'m'};

    return $m_cache[$m]{$MOD} //= sub {
        my $m_ = $m - 2;
        my @f = ($MOD, 0);
        my $next = sub {
            return A_mod($m_, scalar(shift(@_)),@f);
        };

        my $x = $next->(1);
        my @seq = ($x);
        my %cache = ($x => $#seq);

        $x = $next->($x);

        while (!exists($cache{$x}))
        {
            push @seq, $x;
            $cache{$x} = $#seq;
        }
        continue
        {
            $x = $next->($x);
        }

        my $NEW_PREFIX = $cache{$x};
        return +{
            NEW_PREFIX => $NEW_PREFIX,
            NEW_MOD => @seq - $NEW_PREFIX,
            seq => \@seq,
        };
    }->();
}

sub A_mod
{
    my ($m, $n, $MOD, $PREFIX) = @_;

    my $ret = sub {
        if ($m == 0)
        {
            return (($n+1)%$MOD);
        }
        elsif ($m == 1)
        {
            return (($n+2)%$MOD);
        }
        elsif ($m == 2)
        {
            return ((($n<<1)+3)%$MOD);
        }
        elsif ($m == 3)
        {
            return ((((Math::GMP->new('1') << (Math::GMP->new("$n") + 3)) - 3)%$MOD) . '');
        }
        elsif ($n == 0)
        {
            return A_mod($m-1, 1, $MOD, $PREFIX);
        }
        elsif ($m <= 6)
        {
            my $CACHE_RET = get__m__cache({ m => $m, MOD => $MOD});

            my $NEW_PREFIX = $CACHE_RET->{NEW_PREFIX};
            my $NEW_MOD = $CACHE_RET->{NEW_MOD};
            my $seq = $CACHE_RET->{seq};

            if (($NEW_PREFIX == 0) and ($NEW_MOD == 1))
            {
                print "Seq  = [@$seq]\n";
                return $seq->[0];
            }
            my $ret = A_mod($m, ($n-1), $NEW_MOD, $NEW_PREFIX);

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
        die "A_mod($m,$n)!";
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
        print "A_mod($m,$n) = ", A_mod($m, $n, $ULTIMATE_MOD, 0), "\n";
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
        print "A_mod($m,$n) = ", A_mod($m, $n, $ULTIMATE_MOD, 0), "\n";
    }
}

for my $m (6)
{
    for my $n (0 .. 6)
    {
        print "A_mod($m,$n) = ", A_mod($m, $n, $ULTIMATE_MOD, 0), "\n";
    }
}
