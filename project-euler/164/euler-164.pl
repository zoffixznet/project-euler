#!/usr/bin/perl

use strict;
use warnings;
use Math::BigInt lib => 'GMP', ':constant';
use List::MoreUtils qw(all indexes true);
use List::Util qw(sum);

my @counts;

sub update_count
{
    my ( $depth, $penult, $ultimate, $diff ) = @_;

    ( $counts[$depth][$penult][$ultimate] //= 0 ) += $diff;

    return;
}

sub list_digits
{
    my ( $depth, $penult ) = @_;

    return [ indexes { defined } @{ $counts[ $depth - 1 ][$penult] } ];
}

sub get_count
{
    my ( $depth, $penult, $ultimate ) = @_;

    return $counts[ $depth - 1 ][$penult][$ultimate];
}

# Initialize $depth = 2;
#
my $INIT_DEPTH = 2;
for my $penult ( 1 .. 9 )
{
    for my $ult ( 0 .. ( 9 - $penult ) )
    {
        update_count( $INIT_DEPTH, $penult, $ult, 1 );
    }
}

my $MAX_DEPTH = 20;
for my $depth ( $INIT_DEPTH + 1 .. $MAX_DEPTH )
{
    for my $penult ( 0 .. 9 )
    {
        for my $ult ( @{ list_digits( $depth, $penult ) } )
        {
            for my $new ( 0 .. ( 9 - ( $penult + $ult ) ) )
            {
                # print "D=$depth $penult$ult$new\n";
                # STDOUT->flush;
                update_count( $depth, $ult, $new,
                    get_count( $depth, $penult, $ult ) );
            }
        }
    }

    my $sum = sum( map { $_ // 0 } map { @{ $_ // [] } } @{ $counts[$depth] } );
    print "Sum for depth=$depth = $sum\n";

    if (0)
    {
        my $verify = sub {
            my ($n) = @_;

            return all { sum( split //, substr( $n, $_, 3 ) ) <= 9 }
            ( 0 .. ( length($n) - 3 ) );
        };
        my $verify_sum = true { $verify->("$_") }
        ( ( 10**( $depth - 1 ) ) .. ( 10**$depth - 1 ) );
        print "VerifySum for depth=$depth = $verify_sum\n";
    }
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
