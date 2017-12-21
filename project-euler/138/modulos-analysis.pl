#!/usr/bin/perl

use strict;
use warnings;

sub get_valid_n_mods_for_base
{
    my ($base) = @_;

    my %valid_L_squared_mods;

    for my $L ( 0 .. $base - 1 )
    {
        $valid_L_squared_mods{ ( $L * $L ) % $base } = 1;
    }

    my @valid_n_mods;
    for my $n ( 0 .. $base - 1 )
    {
        my $modulo = ( ( 1 + $n * ( 4 + $n * 5 ) ) % $base );
        if ( exists( $valid_L_squared_mods{$modulo} ) )
        {
            push @valid_n_mods, $n;
        }
    }

    return \@valid_n_mods;
}

my $min = undef;
for my $base ( reverse( 2 .. 100_000 ) )
{
    my $mods = get_valid_n_mods_for_base($base);
    if ( !defined $min or @$mods < $min )
    {
        $min = @$mods;
        print "Num Valid 'n's for $base: $min\n";
    }
}

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
