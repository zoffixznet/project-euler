#!/usr/bin/perl

use strict;
use warnings;
use autodie;

package Row;

use MooX qw/late/;

has 'idx' => (isa => 'Int', is => 'ro', required => 1,);

has 'start' => (isa => 'Int', is => 'ro', lazy => 1, default => sub {
        my $self = shift;
        my $n = $self->idx - 1;
        return ((($n * ($n+1)) >> 1) + 1);
    }
);

has 'end' => (isa => 'Int', is => 'ro', lazy => 1, default => sub {
        my $self = shift;
        return $self->start + $self->idx - 1;
    }
);

has '_next' => (is => 'ro', lazy => 1, default => sub {
        my $self = shift;
        return Row->new({idx => ($self->idx+1)});
    }
);

has '_prev' => (is => 'ro', lazy => 1, default => sub {
        my $self = shift;
        return Row->new({idx => ($self->idx-1)});
    }
);

has 'buf' => (is => 'rw', default => sub { my $buf = ''; return (\$buf); },);

sub mark_primes
{
    my ($self) = @_;

    my $top = $self->_next->_next->end;
    my $top_prime = int(sqrt($top));

    my @rows = ($self->_prev->_prev, $self->_prev, $self, $self->_next, $self->_next->_next);

    open my $primes_fh, "primes 2 '$top_prime'|";
    while (my $p = <$primes_fh>)
    {
        chomp($p);
        my $i = $rows[0]->start;
        my $m = $i % $p;
        if ($m != 0)
        {
            $i += $p-$m;
        }

        foreach my $row (@rows)
        {
            my $s = $row->start;
            my $e = $row->end;
            my $buf = $row->buf;

            for(; $i<=$e ; $i += $p)
            {
                vec ($$buf, $i-$s, 1) = 1;
            }
        }
    }
    close($primes_fh);

    return;
}

# Requires mark_primes to be called first.
sub is_prime
{
    my ($self, $col) = @_;

    return (vec(${$self->buf}, $col, 1) == 0);
}

package main;

use Test::More tests => 14;

# TEST
is (Row->new({idx => 1})->start(), 1, "Row[1].start");

# TEST
is (Row->new({idx => 2})->start(), 2, "Row[2].start");

# TEST
is (Row->new({idx => 3})->start(), 4, "Row[3].start");

# TEST
is (Row->new({idx => 4})->start(), 7, "Row[4].start");

# TEST
is (Row->new({idx => 1})->end(), 1, "Row[1].end");

# TEST
is (Row->new({idx => 2})->end(), 3, "Row[2].end");

# TEST
is (Row->new({idx => 3})->end(), 6, "Row[3].end");

# TEST
is (Row->new({idx => 4})->end(), 10, "Row[4].end");

{
    my $row = Row->new({idx => 4});

    $row->mark_primes;
    # TEST
    ok (scalar( $row->is_prime(0) ), "Row[4].is_prime(0)");

    # TEST
    ok (scalar( ! $row->is_prime(1) ), "! Row[4].is_prime(1)");

    # TEST
    ok (scalar( ! $row->is_prime(2) ), "! Row[4].is_prime(2)");
}

{
    my $row = Row->new({idx => 8});

    $row->mark_primes;
    # TEST
    ok (scalar( $row->is_prime(0) ), "Row[8].is_prime(0)");

    # TEST
    ok (scalar( ! $row->is_prime(1) ), "! Row[8].is_prime(1)");

    # TEST
    ok (scalar( $row->is_prime(2) ), "Row[8].is_prime(2)");
}
