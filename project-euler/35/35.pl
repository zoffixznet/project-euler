#!/usr/bin/perl

use strict;
use warnings;

sub is_prime
{
    my ($n) = @_;

    if ( $n <= 1 )
    {
        return 0;
    }

    my $top = int( sqrt($n) );

    for my $i ( 2 .. $top )
    {
        if ( $n % $i == 0 )
        {
            return 0;
        }
    }

    return 1;
}

sub is_circ_prime
{
    my $n = shift;
    if ( $n =~ /0/ )
    {
        return;
    }
    else
    {
        my $l = length($n);
        for my $i ( 1 .. $l )
        {
            if ( !is_prime($n) )
            {
                return;
            }
            $n = substr( $n, 1 ) . substr( $n, 0, 1 );
        }
        return 1;
    }
}

my $count;
foreach my $n ( 2 .. 1_000_000 )
{
    if ( is_circ_prime($n) )
    {
        ++$count;
    }
}
print "$count\n";

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
