package Rand;

use strict;
use warnings;

use MooX qw/late/;

has k => (is => 'rw', isa => 'Int', default => sub { 1; });
has _prev => (is => 'rw', isa => 'ArrayRef', default => sub { []; });

sub _worker4get
{
    my ($self, $n) = @_;

    my $ret = ($n % 1_000_000);
    push @{$self->_prev}, $ret;

    $self->k($self->k + 1);

    return $ret;
}

sub get
{
    my ($self) = @_;

    my $k = $self->k;
    if ($k <= 55)
    {
        return $self->_worker4get(100_003 - 200_003 * $k + 300_007 * $k * $k * $k);
    }
    else
    {
        my $ret = $self->_worker4get($self->_prev->[-24] + $self->_prev->[-55]);
        shift (@{$self->_prev});
        return $ret;
    }
}

1;
