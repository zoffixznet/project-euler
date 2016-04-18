#!/usr/bin/perl

use strict;
use warnings;

package Permutations::Iterator;

sub new
{
    my $class = shift;

    my $self = {};
    bless $self, $class;

    $self->_init(@_);

    return $self;
}


sub _init
{
    my ($self, $set) = @_;

    $self->{stack} =
        [ {prefix => [], set => [@$set], elem => undef, prev => []} ];

    $self->{lim} = (@$set + 1);

    return 0;
}

sub next
{
    my $self = shift;

    my $stack = $self->{stack};
    my $limit = $self->{lim};
    while (@$stack)
    {
        my $s = $stack->[-1];

        if (@$stack == $limit)
        {
            pop(@$stack);
            return $s->{prefix};
        }
        else
        {
            if (defined($s->{elem}))
            {
                push @{$s->{prev}}, $s->{elem};
            }

            if (defined($s->{elem} = shift(@{$s->{set}})))
            {
                push @$stack,
                    {
                        prefix => [@{$s->{prefix}}, $s->{elem}],
                        set => [@{$s->{prev}}, @{$s->{set}}],
                        elem => undef(),
                        prev => [],
                    };
            }
            else
            {
                pop(@$stack);
            }
        }
    }

    return;
}

sub skip
{
    my ($self, $n) = @_;

    my $stack = $self->{stack};
    while (@$stack >= $n+2)
    {
        pop(@$stack);
    }

    return;
}

package main;

use Data::Dumper;
use Math::GMP;

my $set = [reverse(0 .. 9)];

my $iter = Permutations::Iterator->new($set);

my @primes = ([2,2],[3,3],[4,5],[5,7],[6,11],[7,13],[8,17]);
foreach (@primes)
{
    $_->[0]--;
}

my $sum = Math::GMP->new();
my $perm;
PERMUTATIONS:
while (($perm = $iter->next()) && ($perm->[0] != 0))
{
    print "Check: @$perm\n";
    foreach my $s (@primes)
    {
        my ($pos, $prime) = @$s;
        if (join("", @$perm[$pos .. $pos+2]) % $prime)
        {
            print "Pos = $pos\n";
            $iter->skip($pos+2);
            next PERMUTATIONS;
        }
    }
    my $n = Math::GMP->new(join("", @$perm));
    print "Found $n\n";
    $sum += $n;
    print "Sum: $sum\n";
}
print "Total Sum: $sum\n";
