#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $N = shift(@ARGV) || 3;

my $pow = ( 1 << $N );

my %to_n;

sub fill_to_n
{
    my @digits = @_;

    if ( @digits == $N )
    {
        my $s = join '', @digits;
        $to_n{$s} = eval "0b$s";
    }
    else
    {
        for my $b ( 0, 1 )
        {
            fill_to_n( @digits, $b );
        }
    }
    return;
}

fill_to_n();

my $sum = 0;

sub recurse
{
    my ( $s, $bitmask ) = @_;

    if ( @$s == $pow - 1 )
    {
        my @new = ( @$s, 1 );
        for my $i ( $pow - $N + 1 .. $pow - 1 )
        {
            my $n =
                $to_n{ join '', @new[ map { $_ % @new } $i .. $i + $N - 1 ] };
            if ( $bitmask & ( 1 << $n ) )
            {
                return;
            }
            $bitmask |= ( 1 << $n );
        }
        my $x = eval( "0b" . join( '', @new ) );
        $sum += $x;
        print "Found $x ; S = $sum\n";
    }
    else
    {
        for my $b ( 0, 1 )
        {
            my $n = $to_n{ join '', @$s[ -$N + 1 .. -1 ], $b };
            if ( not $bitmask & ( 1 << $n ) )
            {
                recurse( [ @$s, $b ], ( $bitmask | ( 1 << $n ) ) );
            }
        }
    }

    return;
}

recurse( [ (0) x $N ], ( 1 << 0 ) );
print "Final sum = $sum\n";

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
