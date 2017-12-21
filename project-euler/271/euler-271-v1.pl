#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(reduce sum);
use List::MoreUtils qw(all);

use Math::ModInt qw(mod);
use Math::ModInt::ChineseRemainder qw(cr_combine cr_extract);

STDOUT->autoflush(1);

my $N = 13082761331670030;
my @factors =
    ( map { +{ f => int($_), } } (qw(2 3 5 7 11 13 17 19 23 29 31 37 41 43)) );

my @one_factors;
my @multi_factors;
foreach my $f_idx ( keys @factors )
{
    my $f_rec = $factors[$f_idx];
    my @mods;
    my $f = $f_rec->{f};
    for my $m ( 1 .. $f - 1 )
    {
        if ( ( $m**3 ) % $f == 1 )
        {
            push @mods, $m;
        }
    }
    $f_rec->{mods} = \@mods;
    $f_rec->{M} = +{ map { $_ => 1 } @mods };
    if ( @mods == 1 )
    {
        push @one_factors, $f_idx;
    }
    else
    {
        push @multi_factors, $f_idx;
    }
}

print join ",", map { $_->{f} } @factors[@one_factors];
print "\n";

sub product
{
    my $ret = 1;

    foreach my $x (@_)
    {
        $ret *= $x;
    }

    return $ret;
}

sub my_prod
{
    my $aref = shift;

    return product( map { $_->{f} } @factors[@$aref] );
}

my $multi_prod = my_prod( \@multi_factors );
my $one_prod   = my_prod( \@one_factors );

my $one_mod = mod( 1, $one_prod );

my @f = @factors[@multi_factors];

my $total_sum = 0;

sub recurse
{
    my ( $depth, $total_mod ) = @_;

    if ( $depth == @f )
    {
        $total_sum += cr_combine( $one_mod, $total_mod )->residue;
        print "total_sum = $total_sum\n";
    }
    else
    {
        my $factor = $f[$depth]{'f'};
        for my $m ( @{ $f[$depth]{mods} } )
        {
            recurse( $depth + 1, cr_combine( $total_mod, mod( $m, $factor ) ) );
        }
    }

    return;
}

recurse( 0, mod( 1, 1 ) );
print "final total_sum = ", $total_sum - 1, "\n";

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
