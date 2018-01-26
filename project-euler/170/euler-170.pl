#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(sum);
use List::MoreUtils qw(none);

sub gcd
{
    my ( $n, $m ) = @_;

    if ( $m == 0 )
    {
        return $n;
    }

    return gcd( $m, $n % $m );
}

my $COUNT = 10;

sub rec
{
    my ( $in, $out ) = @_;

    if ( length($in) == $COUNT )
    {
        # Do the magic.
        # TODO :
        print "Checking $in\n";
        foreach my $cut_off ( 1 .. length($in) - 1 )
        {
            my $n1 = substr( $in, 0, $cut_off );
            my $n2 = substr( $in, $cut_off );
            my @n_s = ( sort { $a <=> $b } $n1, $n2 );
            if ( none { /\A0/ } @n_s )
            {
                my $gcd = gcd( reverse @n_s );

                for my $d ( 2 .. $gcd )
                {
                    if ( $gcd % $d == 0 )
                    {
                        if (
                            join( '',
                                sort { $a cmp $b }
                                    map { split //, $_ }
                                    ( $d, map { $_ / $d } @n_s ) ) eq
                            '0123456789'
                            )
                        {
                            print "Found «$in» : "
                                . join( " + ",
                                ( map { "$d*" . ( $_ / $d ) } @n_s ) )
                                . " \n";
                            exit(0);
                        }
                    }
                }
            }
        }
        return;
    }

    foreach my $place ( keys @$out )
    {
        rec( $in . $out->[$place],
            [ @$out[ grep { $_ != $place } keys(@$out) ] ] );
    }
}

rec( '', [ reverse( 0 .. 9 ) ] );

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
