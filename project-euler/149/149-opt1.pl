#!/usr/bin/perl

=head1 DESCRIPTION

Looking at the table below, it is easy to verify that the maximum possible sum
of adjacent numbers in any direction (horizontal, vertical, diagonal or
anti-diagonal) is 16 (= 8 + 7 + 1).  −253        2 9−651 3273 −18−4  8

Now, let us repeat the search, b                                        ut on a
much larger scale:

First, generate four million pseudo-random numbers using a specific form of
what is known as a "Lagged Fibonacci Generator":

For 1 ≤ k ≤ 55, sk = [100003 − 200003k + 300007k3] (modulo 1000000) − 500000.
For 56 ≤ k ≤ 4000000, sk = [sk−24 + sk−55 + 1000000] (modulo 1000000) − 500000.

Thus, s10 = −393027 and s100 = 86613.

The terms of s are then arranged in a 2000×2000 table, using the first 2000
numbers to fill the first row (sequentially), the next 2000 numbers to fill the
second row, and so on.

Finally, find the greatest sum of (any number of) adjacent entries in any
direction (horizontal, vertical, diagonal or anti-diagonal).

=cut

use strict;
use warnings;

# use integer;

# use Math::BigInt "lib" => "GMP";

package FiboRand;

sub new
{
    return bless { _k => 1, _last_nums => [] }, shift;
}

# has '_k' => (isa => 'Math::BigInt', is => 'rw', default => sub { return 1; },);
# has '_last_nums' => (isa => 'ArrayRef[Math::BigInt]', is => 'rw', default => sub { return []; },
# traits => ['Array'], handles => { _push => 'push', _shift => 'shift',},);

sub fetch
{
    my $self = shift;

    my $k = $self->{_k};
    my $s_k;

    my $ln = $self->{_last_nums};

    if ($k <= 55)
    {
        $s_k = (((100003 - 200003*$k + 300007*($k**3)) % 1000000) - 500000);
    }
    else
    {
        $s_k = ((($ln->[-24] + $ln->[-55] + 1000000) % 1000000) - 500000);
        shift(@$ln);
    }
    push @$ln, $s_k;
    $self->{_k}++;

    return $s_k;
}

package main;

# Unit test to the randomizer.
{
    my $rand = FiboRand->new;

    if (0)
    {
    foreach my $k (1 .. 100)
    {
        print "$k = ", $rand->fetch(), "\n";
    }
    }

    $rand = FiboRand->new;

    for my $k ( 1 .. 9)
    {
        $rand->fetch();
    }

    if ($rand->fetch() != -393027)
    {
        die "Wrong s10!";
    }

    for my $k (11 .. 99)
    {
        $rand->fetch();
    }

    if ($rand->fetch() != 86613)
    {
        die "Wrong s100!";
    }
}

package Max;

# s = so far
# e = ending here.
sub new
{
    return bless { s => 0, e => 0 }, shift;
}

sub _max
{
    my ($x, $y) = @_;

    return ($x > $y) ? $x : $y;
}

sub add
{
    my ($self, $n) = @_;
 
    $self->{'s'} = _max($self->{'s'}, ($self->{e} = _max($self->{e} + $n, 0)));

    return;
}

sub get_max
{
    my ($self) = @_;

    return $self->{'s'};
}

package main;

my $rand = FiboRand->new;

sub max
{
    my ($x, $y) = @_;

    return ($x > $y) ? $x : $y;
}

my $SIZE = 2_000;

my $horiz_max_max = 0;
my @vert_max = map { Max->new } (1 .. $SIZE);
my @diag_max = map { Max->new } (1 .. $SIZE);
my @anti_diag_max = map { Max->new } (1 .. $SIZE);
my $diag_max_max = 0;
my $anti_diag_max_max = 0;

my $diag_offset = 0;
my $anti_diag_offset = 0;

sub handle_row
{
    my $horiz = Max->new;
    # First row.
    foreach my $x (0 .. $SIZE-1)
    {
        my $s = $rand->fetch();

        $vert_max[$x]->add($s);
        $horiz->add($s);
        $diag_max[($x+$diag_offset) % $SIZE]->add($s);
        $anti_diag_max[($x+$anti_diag_offset) % $SIZE]->add($s);
    }

    $horiz_max_max = max($horiz_max_max, $horiz->get_max());

    $diag_max_max = max($diag_max_max, $diag_max[0]->get_max());
    $diag_max[0] = Max->new;
    $diag_offset++;

    $anti_diag_max_max = max($anti_diag_max_max, $anti_diag_max[-1]->get_max());
    $anti_diag_max[-1] = Max->new;
    $anti_diag_offset--;

    return;
}

foreach my $y (1 .. $SIZE)
{
    if ($y % 100 == 0)
    {
        print "$y\n";
    }
    handle_row();
}

sub multi_max
{
    my $aref = shift;

    my $max = 0;

    foreach my $n (@$aref)
    {
        if ($n > $max)
        {
            $max = $n;
        }
    }
    return $max;
}

print "Result = ", multi_max(
    [
    $horiz_max_max, $anti_diag_max_max, $diag_max_max, (map { $_->get_max() } @vert_max, @diag_max, @anti_diag_max
    )
    ]
), "\n";
