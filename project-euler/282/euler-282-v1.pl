#!/usr/bin/perl

use strict;
use warnings;

no warnings 'recursion';

use Math::GMP;

use integer;
use bytes;

use List::Util qw(first sum);
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
    my ($m, $MOD, $PREFIX) = @_;

    return @{ $m_cache[$m]{$MOD}{$PREFIX} //= sub {
        my $m_ = $m - 2;
        my @f = ($MOD, $PREFIX);
        my $next = sub {
            return A_mod($m_, scalar(shift(@_)),@f);
        };

        # my $x = 1;
        my $x = A_mod($m-1, 0, @f);

=begin More Correct Solution.

        my @seq;
        my %cache;

        while (!exists($cache{$x}))
        {
            push @seq, $x;
            $cache{$x} = $#seq;
            $x = $next->($x);
        }

        my $NEW_PREFIX = $cache{$x};
        return [ (@seq - $NEW_PREFIX), $NEW_PREFIX, \@seq ];

=end More Correct Solution.

=cut

        my $seq = '';
        my $L = '';
        my $i = 0;

        if ($m_ == 1)
        {
            while (! vec($L, $x, 1))
            {
                vec( $seq, $i++, 32 ) = $x;
                vec( $L, $x, 1 ) = 1;

                if (($x += 2) >= $PREFIX+$MOD)
                {
                    $x = (($x - $PREFIX) % $MOD + $PREFIX);
                }
            }
        }
        else
        {
            while (! vec($L, $x, 1))
            {
                vec( $seq, $i++, 32 ) = $x;
                vec( $L, $x, 1 ) = 1;
                $x = $next->($x);
            }
        }

        my $NEW_PREFIX = first { vec($seq, $_, 32) == $x } 0 .. $i;
        return [ ($i - $NEW_PREFIX), $NEW_PREFIX, \$seq ];

    }->() };
}

=begin foo

sub A_mod
{
    return A_mod_proto(map { Math::GMP->new($_) } @_[0 .. 3]);
}

=end foo

=cut

sub A_mod
{
    my ($m, $n, $MOD, $ORIG_PREFIX) = @_;

    if (($ORIG_PREFIX == 0) and ($MOD == 1))
    {
        return 0;
    }

    my $PREFIX = $ORIG_PREFIX;
    my $ORIG_ME = ($m > 3);
    if ($ORIG_ME and $PREFIX)
    {
        $PREFIX = 0;
    }

    my $Map = sub {
        my $x = shift;
        return (($x < $PREFIX + $MOD) ? $x : (($x-$PREFIX) % $MOD + $PREFIX));
    };

    my $ret = sub {
        if ($m == 0)
        {
            return $Map->($n+1);
        }
        elsif ($m == 1)
        {
            return $Map->($n+2);
        }
        elsif ($m == 2)
        {
            return $Map->(($n<<1)+3);
        }
        # elsif (0)
        elsif ($m == 3)
        {
            # my $ret1 = $Map->((Math::GMP->new('1') << (Math::GMP->new("$n") + 3)) - 3) . '';
            my $ret2;
            if ($PREFIX == 0)
            {
                 $ret2 = $Map->(exp_mod(2, $n+3, $MOD) + $MOD*4 - 3);
            }
            else
            {
                my $verdict = 0;
                {
                    no integer;
                    if (log($PREFIX)/log(2) < $n + 2)
                    {
                        $verdict = 1;
                    }
                }

                if ($verdict)
                {
                    $ret2 = exp_mod(2, $n+3, $MOD);
                    if ($ret2 < $PREFIX)
                    {
                        $ret2 += $MOD;
                    }
                    $ret2 = $Map->($ret2 + $MOD*4 - 3);
                }
                else
                {
                    $ret2 = $Map->((Math::GMP->new('1') << (Math::GMP->new("$n") + 3)) - 3) . '';
                }
            }
            if (0) # if ($ret2 != $ret1)
            {
                # die "Incorrect $ret1 / $ret2 ret1/ret2!";
            }
            return $ret2;
        }
        elsif ($n == 0)
        {
            return A_mod($m-1, 1, $MOD, $PREFIX);
        }
        elsif ($m <= 6)
        {
            my ($NEW_MOD, $NEW_PREFIX, $seq) = get__m__cache($m, $MOD, $PREFIX);

            my $r_idx = A_mod($m, ($n-1), $NEW_MOD, $NEW_PREFIX);

            # my $r = $cache{$ret};
            # my $r = $seq->[$r_idx];

            return vec(${$seq}, $r_idx, 32);
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

    if ($ORIG_ME and $ORIG_PREFIX and ($ret < $ORIG_PREFIX))
    {
        $ret += $MOD;
    }

    if (0)
    {
        my $want = $Map->(A($m,$n));

        if ($want != $ret)
        {
            die "A_mod($m,$n, $MOD, $PREFIX)!";
        }
    }

    # print "A($m,$n) = $ret\n";

    return $ret;
}


sub exp_mod
{
    my ($base, $exp, $mod) = @_;

    if ($exp == 0)
    {
        return 1;
    }
    my $rec = exp_mod($base, $exp >> 1, $mod);
    my $ret = ($rec * $rec) % $mod;
    if ($exp & 1)
    {
        $ret = (($ret * $base) % $mod);
    }
    return $ret;
}

{
    my %Cache1;
sub hyperexp_modulo
{
    my ($base, $exp, $mod, $prefix) = @_;

    my $DEFAULT_RET = 0;

    my $Map = sub {
        my $x = shift;
        return (($x < $prefix) ? $x : (($x-$prefix) % $mod + $prefix));
    };

    my $ret;

    if ($exp == 1)
    {
        $ret = $Map->($base);
        # return $base;
    }
    elsif (($mod == 1) and ($prefix == 0))
    {
        $ret = $DEFAULT_RET;
    }
    else
    {
        my $T = sub {
            return $Map->(shift(@_) * $base);
        };

        my $_calc = sub {
            my $x = 1;
            my %cache;
            my @seq;

            while (!exists($cache{$x}))
            {
                push @seq, $x;
                $cache{$x} = $#seq;
                $x = $T->($x);
            }

            my $PREFIX = $cache{$x};
            return [$PREFIX, (@seq-$PREFIX), \@seq];
        };

        my ($PREFIX, $LEN, $SEQ) = @{
            $Cache1{$base}{$exp}{$prefix}{$mod} //= $_calc->()
        };

        my $mod_recurse = hyperexp_modulo($base, $exp-1, $LEN, $PREFIX);

        # TODO : Verification code - remove later.
        if (0)
        {
            my $d = Math::GMP->new($base);

            for my $i (1 .. $exp-1-1)
            {
                $d = $base ** $d;
            }

            if ((($d < $PREFIX) ? $d : (($d-$PREFIX) % $LEN + $PREFIX))
                != $mod_recurse)
            {
                if (! $ENV{D})
                {
                    die "Incorrect result (hyperexp_modulo($base, $exp-1, $LEN, $PREFIX, $base); !";
                }
            }
        }
        $ret = $SEQ->[$mod_recurse];
        # TODO : Disable.
        if (0)
        {
            my $d = Math::GMP->new($base);

            for my $i (1 .. $exp-1)
            {
                $d = $base ** $d;
            }

            if ((($d < $prefix) ? $d : (($d-$prefix) % $mod + $prefix))
                != $ret)
            {
                if (! $ENV{D})
                {
                    die "Incorrect result CHECK-INNER (hyperexp_modulo(@_); !";
                }
            }
        }
    }

    # TODO : Disable.
    if (0)
    {
        my $d = Math::GMP->new($base);

        for my $i (1 .. $exp-1)
        {
            $d = $base ** $d;
        }

        if ((($d < $prefix) ? $d : (($d-$prefix) % $mod + $prefix))
                != $ret)
        {
            if (! $ENV{D})
            {
                die "Incorrect result CHECK (hyperexp_modulo(@_); !";
            }
        }
    }

    return $ret;
}
}

my $TEST_MOD = $ULTIMATE_MOD;
# my $TEST_MOD = 37;
# my $TEST_MOD = 305607;

for my $m (0 .. 3)
{
    for my $n (0 .. 100)
    {
        print "A($m,$n) = ", ( A($m,$n) % $ULTIMATE_MOD ), "\n";
    }
}

for my $m (3)
{
    for my $n (0 .. 100)
    {
        print "A_mod($m,$n) = ", A_mod($m, $n, $ULTIMATE_MOD, 0), "\n";
    }
}

for my $m (4)
{
    for my $n (0 .. 2)
    {
        # print "A($m,$n) = ", (A($m,$n) % $ULTIMATE_MOD), "\n";
        print "A($m,$n) = ", (A($m,$n) % $TEST_MOD), "\n";
        # print "A[t]($m,$n) = ", ((hyperexp_modulo(2, $n+3, $TEST_MOD, 0) + $TEST_MOD - 3) % $TEST_MOD), "\n";
    }
    for my $n (3 .. 10)
    {
        # print "A[t]($m,$n) = ", ((hyperexp_modulo(2, $n+3, $TEST_MOD, 0) + $TEST_MOD - 3) % $TEST_MOD), "\n";
    }
}

for my $m (4)
{
    for my $n (0 .. 10)
    {
        # print "A_mod($m,$n) = ", A_mod($m, $n, $ULTIMATE_MOD, 0), "\n";
        print "A_mod($m,$n) = ", A_mod($m, $n, $TEST_MOD, 0), "\n";
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
