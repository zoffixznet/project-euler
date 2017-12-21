#!/usr/bin/perl

use strict;
use warnings;
use utf8;

use List::Util qw/ min max /;
use POSIX qw/ ceil floor /;

sub rec
{
    my ( $n, $so_far, $i ) = @_;

    print "So far: "
        . join( ", ",
        map { ref($_) eq 'ARRAY' ? "$_->[0]→$_->[1]" : $_ } @$so_far )
        . "\n";
    if ( $i == 1 )
    {
        return rec(
            $n,
            [
                2,
                (
                    map {
                        my $j   = $_;
                        my $x_i = 2;
                        [
                            1 + floor( -1 + $x_i**( $j / $i ) ),
                            -1 + ceil( ( $x_i + 1 )**( $j / $i ) )
                        ]
                    } 2 .. $n
                )
            ],
            $i + 1
        );
    }
    elsif ( $i > $n )
    {
        print "Found [@$so_far]\n";
    }
    else
    {
        my ( $bottom, $top ) = @{ $so_far->[ $i - 1 ] };
    X_I:
        foreach my $x_i ( $bottom .. $top )
        {
            my @new = @$so_far;
            $new[ $i - 1 ] = $x_i;
            foreach my $j ( $i + 1 .. $n )
            {
                my $old = $new[ $j - 1 ];
                my $new = [
                    max( 1 + floor( -1 + $x_i**( $j / $i ) ), $old->[0] ),
                    min( -1 + ceil( ( $x_i + 1 )**( $j / $i ) ), $old->[1] )
                ];
                if ( $new->[0] > $new->[1] )
                {
                    next X_I;
                }
                $new[ $j - 1 ] = $new;
            }
            rec( $n, \@new, $i + 1 );
        }
    }
}

binmode STDOUT, ':encoding(utf8)';

rec( shift(@ARGV), [], 1 );

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
