package Rand;

use strict;
use warnings;

use integer;
use bytes;

use MooX qw/late/;

has k     => ( is => 'rw', isa => 'Int',      default => sub { 1; } );
has _prev => ( is => 'rw', isa => 'ArrayRef', default => sub { []; } );

sub _worker4get
{
    my ( $self, $n ) = @_;

    my $ret = ( $n % 1_000_000 );
    push @{ $self->_prev }, $ret;

    $self->k( $self->k + 1 );

    return $ret;
}

sub get
{
    my ($self) = @_;

    my $k = $self->k;
    if ( $k <= 55 )
    {
        return $self->_worker4get(
            100_003 - 200_003 * $k + 300_007 * $k * $k * $k );
    }
    else
    {
        my $ret =
            $self->_worker4get( $self->_prev->[-24] + $self->_prev->[-55] );
        shift( @{ $self->_prev } );
        return $ret;
    }
}

1;

=head1 COPYRIGHT & LICENSE

Copyright 2017 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

=cut
