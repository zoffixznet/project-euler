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

            if ($s->{elem} = shift(@{$s->{set}}))
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

use Data::Dumper;

my $set = [1, 22, 303, 4400, 51, 607, 789];

my $self = Permutations::Iterator->new($set);

while (defined(my $p = $self->next()))
{
    print join(",", @$p), "\n";
}
