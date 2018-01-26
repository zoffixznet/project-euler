#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(min sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my @factorials = (1);
for my $n ( 1 .. 9 )
{
    push @factorials, $factorials[-1] * $n;
}

my $sum = 0;
my @g;
my $count = 0;

my $num_digits = 1;
my $SEEK       = 150;
while ( $count < $SEEK )
{
    my $recurse;

    $recurse = sub {
        my ( $n, $d ) = @_;

        my $remain = $num_digits - length($n);

        if ( !$remain )
        {
            my $f = sum( @factorials[ split //, $n ] );
            my $sf = sum( split //, $f );

            if ( $sf <= $SEEK )
            {
                if ( !defined( $g[$sf] ) )
                {
                    $count++;
                    $g[$sf] = $n;
                    $sum += sum( split //, $n );
                    print "Found g($sf) == $n (f=$f) [Count=$count]\n";
                    if ( $count == $SEEK )
                    {
                        return 1;
                    }
                }
            }

            return;
        }
        else
        {
            for my $e (
                ( $d == 9 ) ? ($remain) : reverse( 0 .. min( $remain, $d ) ) )
            {
                if ( $recurse->( $n . ( $d x $e ), $d + 1 ) )
                {
                    return 1;
                }
            }
            return;
        }
    };

D_LOOP:
    for my $d ( 1 .. 9 )
    {
        if ( $recurse->( '', $d ) )
        {
            last D_LOOP;
        }
    }
}
continue
{
    $num_digits++;
}
print "Sum == $sum\n";

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
