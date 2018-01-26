#!/usr/bin/perl

use strict;
use warnings;

sub gen_perms
{
    my ($set) = @_;

    if ( @$set == 0 )
    {
        return [ [] ];
    }

    my $elem;
    my @prev_elems;
    my @perms;
    while ( defined( $elem = shift(@$set) ) )
    {
        push @perms,
            ( map { [ $elem, @{$_} ] }
                @{ gen_perms( [ @prev_elems, @$set ] ) } );
        push @prev_elems, $elem;
    }

    return \@perms;
}

my $COUNT = shift(@ARGV);

my @perms = @{ gen_perms( [ 1 .. $COUNT ] ) };

foreach my $len ( 0 .. $COUNT )
{
    my %found = ();

    my $count = 0;

    foreach my $p (@perms)
    {
        my @sub_p = @$p[ 0 .. $len - 1 ];

        if ( !$found{ join( ',', @sub_p ) }++ )
        {
            if ( 1 == grep { $sub_p[ $_ + 1 ] < $sub_p[$_] }
                ( 0 .. $#sub_p - 1 ) )
            {
                $count++;
            }
        }
    }
    printf "Count[%2d] = %d\n", $len, $count;
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
