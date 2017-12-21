#!/usr/bin/perl

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

    if ( $k <= 55 )
    {
        $s_k = ( ( ( 100003 - 200003 * $k + 300007 * ( $k**3 ) ) % 1000000 ) -
                500000 );
    }
    else
    {
        $s_k = ( ( ( $ln->[-24] + $ln->[-55] + 1000000 ) % 1000000 ) - 500000 );
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
        foreach my $k ( 1 .. 100 )
        {
            print "$k = ", $rand->fetch(), "\n";
        }
    }

    $rand = FiboRand->new;

    for my $k ( 1 .. 9 )
    {
        $rand->fetch();
    }

    if ( $rand->fetch() != -393027 )
    {
        die "Wrong s10!";
    }

    for my $k ( 11 .. 99 )
    {
        $rand->fetch();
    }

    if ( $rand->fetch() != 86613 )
    {
        die "Wrong s100!";
    }
}

package Max;

use List::Util qw(max);

# s = so far
# e = ending here.
sub new
{
    return bless { s => 0, e => 0 }, shift;
}

sub add
{
    my ( $self, $n ) = @_;

    $self->{'s'} =
        max( $self->{'s'}, ( $self->{e} = max( $self->{e} + $n, 0 ) ) );

    return;
}

# g = get()
sub g
{
    my ($self) = @_;

    return $self->{'s'};
}

package main;

use List::Util qw(max);

my $rand = FiboRand->new;

my $SIZE = 2_000;

my $max_max       = 0;
my @vert_max      = map { Max->new } ( 1 .. $SIZE );
my @diag_max      = map { Max->new } ( 1 .. $SIZE );
my @anti_diag_max = map { Max->new } ( 1 .. $SIZE );

my $diag_offset      = 0;
my $anti_diag_offset = 0;

sub handle_row
{
    my $horiz = Max->new;

    # First row.
    foreach my $x ( 0 .. $SIZE - 1 )
    {
        my $s = $rand->fetch();

        $vert_max[$x]->add($s);
        $horiz->add($s);
        $diag_max[      ( $x + $diag_offset ) % $SIZE ]->add($s);
        $anti_diag_max[ ( $x + $anti_diag_offset ) % $SIZE ]->add($s);
    }

    $max_max = max( $max_max, $horiz->g(), $diag_max[0]->g(),
        $anti_diag_max[-1]->g() );

    $diag_max[0] = Max->new;
    $diag_offset++;

    $anti_diag_max[-1] = Max->new;
    $anti_diag_offset--;

    return;
}

foreach my $y ( 1 .. $SIZE )
{
    if ( $y % 100 == 0 )
    {
        print "$y\n";
    }
    handle_row();
}

print "Result = ",
    max( $max_max, ( map { $_->g() } @vert_max, @diag_max, @anti_diag_max ) ),
    "\n";

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
