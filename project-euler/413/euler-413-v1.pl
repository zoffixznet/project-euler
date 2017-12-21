#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use DivideFsm;

STDOUT->autoflush(1);

sub solve_for_d
{
    my ($D) = @_;

    # Both 0 and x0 are divisible.
    if ( $D == 10 )
    {
        return 0;
    }

    my ($g) = DivideFsm::get_div_fsms($D);
    my @A = @$g;

    # A transposed
    my @T = map {
        my $d = $_;
        [ map { $A[$_][$d] } keys @A ]
    } keys @{ $A[0] };

    my $rec;

    # my @S = ((0) x $D);
    # D *M*inus 1.
    my $M = $D - 1;

    my %cache;

    $rec = sub {
        my ( $i, $S, $count ) = @_;

        my $key = ( join ',', $count, sort { $a <=> $b } @$S );

        if ( exists $cache{$key} )
        {
            return $cache{$key};
        }
        if (0)
        {
            if ( $D == 8 )
            {
                print "Sorted = $key\n";
            }
        }

        if ( $i == $D )
        {
            return ( $cache{$key} = $count );
            {
                if (0)
                {
                    # $_n = scalar reverse$_n;
                    my $_n = scalar reverse @$S[ 0 .. $D ];
                    if (
                        (
                            map {
                                my $s = $_;
                                grep {
                                    my $e = $_;
                                    substr( $_n, $s, $e - $s + 1 ) % $D == 0
                                    } $s .. length($_n) - 1
                            } 0 .. length($_n) - 1
                        ) != 1
                        )
                    {
                        print "False $_n\n";
                    }
                }
            }
        }
        else
        {
            my $ret = 0;

        NEW:
            foreach my $r ( @T[ ( ( ( $count == 0 ) && $i ) ? 0 : 1 ) .. 9 ] )
            {
                my @N = @$r[ @$S, 0 ];

                # $nc == new_count
                my $nc = $count + ( grep { $_ == 0 } @N );
                if ( $nc < 2 )
                {
                    $ret += $rec->( $i + 1, \@N, $nc );
                }
            }
            return $cache{$key} = $ret;
        }
    };

    my $ret = $rec->( 0, [], 0 );

    $rec = 0;

    return $ret;
}

my @sums;

$sums[0] = 0;

for my $d ( 1 .. 7 )
{
    $sums[$d] = $sums[ $d - 1 ] + solve_for_d($d);
    print "F(" . 10**$d . ") = " . $sums[$d] . "\n";
}

# for my $d (8 .. 8)
for my $d ( 8 .. 19 )
{
    print "Calcing d=$d\n";
    $sums[$d] = $sums[ $d - 1 ] + solve_for_d($d);
}

print map { "F(" . 10**$_ . ") = " . $sums[$_] . "\n" } keys(@sums);

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
