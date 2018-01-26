#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();
use List::UtilsBy qw(min_by);

STDOUT->autoflush(1);

use File::Spec;
use File::Basename (qw( basename dirname ));
use File::Temp     (qw/ tempfile tempdir /);
use File::Path     (qw/ rmtree mkpath /);

use IO::All qw / io /;

my @primes = io('primes.txt')->chomp->getlines;

package Stream;

use integer;

sub new
{
    my $class = shift;

    my $self = bless {}, $class;

    $self->_init(@_);

    return $self;
}

sub _init
{
    my ( $self, $args ) = @_;

    $self->{'q'} = $args->{'q'};

    $self->{'i'} = -1;

    $self->advance;

    return;
}

sub val
{
    my ($self) = @_;

    return $self->{'q'}**3 * $primes[ $self->{'i'} ]**2;
}

sub advance
{
    my ($self) = @_;

    if ( $primes[ ++$self->{'i'} ] == $self->{'q'} )
    {
        ++$self->{'i'};
    }

    return;
}

package main;

sub sqube_stream
{
    my @streams;

    my $new_stream = sub {
        push @streams, Stream->new( { q => $primes[ scalar @streams ] } );
    };
    $new_stream->();

    return sub {
        my $idx = min_by { $streams[$_]->val } keys @streams;
        if ( $idx == $#streams )
        {
            $new_stream->();
        }
        my $ret = $streams[$idx]->val;
        $streams[$idx]->advance;

        return $ret;
    };
}

my $s = sqube_stream;

say $s->() while 1;

=head1 COPYRIGHT & LICENSE

Copyright 2018 by Shlomi Fish

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
