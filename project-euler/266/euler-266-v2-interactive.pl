#!/usr/bin/perl

use strict;
use warnings;

use Math::GMP;
use bytes;

use JSON::MaybeXS qw(decode_json encode_json);
use Path::Tiny qw/path/;

use List::Util qw(sum);
use List::MoreUtils qw(any);

STDOUT->autoflush(1);

# Prime strings.
my @p_s = `primes 2 190`;
chomp(@p_s);

sub gn
{
    return Math::GMP->new(shift);
}

# The primes.
my @p = ( map { gn($_) } @p_s );

sub product
{
    my $ret = gn(1);

    $ret *= $_ foreach @_;

    return $ret;
}

my $N = product(@p);

my $SQ = $N->bsqrt;

sub my_eval
{
    my $coords = shift;

    if ( any { $_ < 0 or $_ > $#p } @$coords )
    {
        die "Coords out of range.";
    }

    if ( ( join ",", @$coords ) ne ( join ",", sort { $a <=> $b } @$coords ) )
    {
        die "Coords are not sorted.";
    }

    return +{
        coords => [@$coords],
        prod   => ( product( @p[@$coords] ) . '' ),
    };
}

my $fn   = './266_DATA.json';
my $fh   = path($fn);
my $data = ( -e $fn ) ? decode_json( $fh->slurp_utf8() ) : +{
    upper => [ my_eval( [ keys @p ] ) ],
    lower => [ my_eval( [] ) ],
};

sub add
{
    my ( $key, $coords ) = @_;

    my $e  = my_eval($coords);
    my $ep = gn( $e->{prod} );
    if ( $key eq 'u' )
    {

        if ( $ep < $SQ )
        {
            die "Upper Product is smaller than the pivot";
        }

        if ( $ep >= gn( $data->{upper}->[-1]->{prod} ) )
        {
            die "Upper Product does not improve on the limit.";
        }

        push @{ $data->{upper} }, $e;

    }
    elsif ( $key eq 'l' )
    {

        if ( $ep > $SQ )
        {
            die "Lower Product is larger than the pivot";
        }

        if ( $ep <= gn( $data->{lower}->[-1]->{prod} ) )
        {
            die "Lower Product does not improve on the limit.";
        }

        push @{ $data->{lower} }, $e;

    }
    else
    {
        die "Unknown operation '$key'!";
    }

    $fh->spew_utf8( encode_json($data) );
}

# Summary.
sub S
{
    return [
        { l     => $data->{lower}->[-1] },
        { u     => $data->{upper}->[-1] },
        { PIVOT => "$SQ" },
    ];
}

$DB::single = 1;

while (1)
{
    print "Continuing\n";
}

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
