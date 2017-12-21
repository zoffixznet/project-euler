#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Euler165::Seg
    qw($TYPE_X_ONLY $TYPE_XY compile_segment intersect intersect_x);
use Euler165::R;

STDOUT->autoflush(1);

my %points;
my $total = 0;

my $r = Euler165::R->new;

my ( @x_segs, @xy_segs );

for my $n ( 1 .. 5000 )
{
    print "N=$n\n";
    my $seg_points = $r->get_seg;
    my $seg        = compile_segment($seg_points);

    if ( $seg->{t} == $TYPE_X_ONLY )
    {
        push @x_segs, $seg;
    }
    else
    {
        push @xy_segs, $seg;
    }
}

@xy_segs = ( sort { $a->{'x1'} <=> $b->{'x1'} or $a->{'x2'} <=> $b->{'x2'} }
        @xy_segs );

sub _check
{
    my ($p) = @_;
    if ( defined $p )
    {

=begin foo
        A sanity check that never gets triggered:

        if (grep { $_->[1] <= 0 } @$p)
        {
            die "Wrong!";
        }

=end foo

=cut

        $total++;

        # print "==Found [$s]\n";
        $points{ join( "!", map { @$_ } @$p ) } = undef;
    }
}

sub f
{
    my $f = shift;
    return $f->[0] / $f->[1];
}

sub e
{
    my ( $x, $y ) = @_;
    return ( abs( $x - $y ) <= 0.001 );
}

my $first = 0;
while ( $first < @xy_segs )
{
    my $s1 = $xy_segs[$first];
    my $x2 = $s1->{'x2'};
    my $y1 = $s1->{'y1'};
    my $y2 = $s1->{'y2'};

    for my $s2 ( grep { $_->{x} > $s1->{'x1'} }
        ( @x_segs = grep { $_->{x} < $x2 } @x_segs ) )
    {
        _check( intersect_x( $s2, $s1 ) );
    }
I2:
    for my $i2 ( $first + 1 .. $#xy_segs )
    {
        my $s2 = $xy_segs[$i2];

        if ( $s2->{'x1'} >= $x2 )
        {
            last I2;
        }

        if ( $y1 <= $s2->{'y2'} and $y2 >= $s2->{'y1'} )
        {
            _check( intersect( $s1, $s2 ) );
        }

=begin SanityCheck

        my $p = intersect($s1,$s2);
        if (defined($p))
        {
            my $x = f($p->[0]);
            if ($x <= $s1->{'x1'} or $x >= $s1->{'x2'}
                    or $x <= $s2->{'x1'} or $x >= $s2->{'x2'})
            {
                die "X is out of range for I2=$i2\n";
            }
            my $y = f($p->[1]);
            if (not e(f($s1->{'m'})*$x+f($s1->{'b'}), $y))
            {
                die "Wrong result for I2=$i2 s1.";
            }
            if (not e(f($s2->{'m'})*$x+f($s2->{'b'}), $y))
            {
                die "Wrong result for I2=$i2 s2.";
            }
            _check($p);
        }
=end

=cut

    }
    print "Reached $first/$#xy_segs.\n";
    $first++;
}

print "Num intersections == ", scalar( keys %points ), "\n";
print "Total = $total\n";

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
