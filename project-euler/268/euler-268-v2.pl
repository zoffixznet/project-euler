#!/usr/bin/perl

use strict;
use warnings;

# use integer;
use bytes;

# use Math::BigInt lib => 'GMP';

use List::Util qw(min max sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my @primes = map { 0 + $_ } `primes 2 100`;
my @logs = map { log($_) } @primes;

my $L = 1_0000_0000_0000_0000;
# my $L = (10 ** 16);
# my $L = 1_000_000;
# my $L = 1_000;

my $LOG_L = log($L);

my $total = 0;

my $MAX_C = (1 << 25);
my $ITER = 1_000;
my $count = 0;
my $next_iter = $ITER;

my %gross_sizes;

sub f
{
    # $i is index to start from.
    # $c is count.
    # $mul is the product
    my ($i, $c, $mul, $mul_l) = @_;

    # print "\@_ = @_\n";
    if ($mul_l > $LOG_L)
    {
        return;
    }

    if ($i == @primes)
    {
        if (++$count == $next_iter)
        {
            print "Reached $count/$MAX_C\n";
            $next_iter += $ITER;
        }
        if (@$c >= 4)
        {
            my $offset = int( $L / $mul );
            $gross_sizes{"@$c"} = $offset;

=begin removed.
            if (@$c > 4)
            {
                for my $pos (0 .. $#$c)
                {
                    my @link = @$c;
                    splice(@link, $pos, 1);
                    push @{$links{"@link"}}, $c;
                }
            }
=end removed

=cut

            if (0)
            {
                my $sub = $c & 0x1;
                $total += ($c == 4 ? $offset : (($sub ? -1 : 1) * ($c-1) * $offset));
                if (0)
                {
                    my $sub = $c & 0x1;
                    if (1)
                    {
                        for my $x (1 .. $offset)
                        {
                            my $n = $x * $mul;
                            printf "%sN = %d : %s\n",
                            ($sub ? "-" : "+"),
                            $n,
                            join(" ", grep { $n % $_ == 0 } @primes)
                            ;
                        }
                    }

                    if ($sub)
                    {
                        $total -= $offset;
                    }
                    else
                    {
                        $total += $offset;
                    }
                }
            }
        }
    }
    else
    {
        f($i + 1, $c, $mul, $mul_l);
        f($i + 1, [@$c,$i], $mul*$primes[$i], $mul_l + $logs[$i]);
    }
    return;
}

f(0, [], 1, 0);

my %net_sizes;

sub calc_links
{
    my ($c, $s) = @_;

    my @ret;

    for my $in (-1 .. $#$c)
    {
        for my $add (
            (($in == -1 ? -1 : $c->[$in])+1)
                ..
            (($in == $#$c ? scalar(@primes) : $c->[$in+1])-1)
        )
        {
            my @new = (@$c[0 .. $in], $add, @$c[$in+1 .. $#$c]);
            my $n = "@new";
            if (exists $gross_sizes{$n})
            {
                push @ret , [\@new, $n];
            }
        }
    }

    return \@ret;
}

sub n
{
    my ($c, $s) = @_;

    return $net_sizes{$s} //=
    sub {
        my $size = $gross_sizes{$s};

        my @Q = @{ calc_links($c, $s) };
        my %seen = (map { +($_->[1] => undef()) } @Q);
        while (defined(my $krec = shift(@Q)))
        {
            my ($k, $ks) = @$krec;
            $size -= n($k, $ks);

            for my $next_k (@{ calc_links($k, $ks) })
            {
                my $n_s = $next_k->[1];
                if (!exists($seen{$n_s}))
                {
                    $seen{$n_s} = undef();
                    push @Q, $next_k;
                }
            }
        }

        $total += $size;

        return $size;
    }->();
}

my $LIM = keys(%gross_sizes);
$count = 0;
foreach my $k (keys(%gross_sizes))
{
    printf "Inspecting %d/%d\n", ($count++, $LIM);
    n([split / /, $k], $k);
}

if (0)
{
    my $fh = io->file("bad.dump");
    foreach my $k (keys(%net_sizes))
    {
        my $v = $net_sizes{$k};
        my @key = @primes[split/ /,$k];
        for my $i (1 .. $v)
        {
            $fh->print(": @key\n");
        }
    }
}

# Got 77579 for $L = 1_000_000;
# Should be 77579.
# Yay!
print "total = $total\n";
