#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

my $COUNT_DIGITS = 16;
my $L            = $COUNT_DIGITS - 1;

# Correct/True
my $T = $COUNT_DIGITS;

# Remaining.
my $R  = $T + 1;
my $TR = ( $T >> 1 );

# $Y == Yes.
my $Y = 11;

# $N == No.
my $N = 12;

use List::MoreUtils qw(all);

use Algorithm::ChooseSubsets;

# my %is_d = (map { $_ => undef() } (0 .. 9));

my @_fact = ( 1, 1 );
foreach my $n ( 2 .. $COUNT_DIGITS )
{
    push @_fact, $_fact[-1] * $n;
}

my @_nC2;

foreach my $sum ( 0 .. $COUNT_DIGITS )
{
    foreach my $x ( 0 .. $sum )
    {
        $_nC2[ ( $x << 8 ) | $sum ] =
            ( $_fact[$sum] / ( $_fact[$x] * $_fact[ $sum - $x ] ) );
    }
}

my @_Ds = ( map { my $s = ''; vec( $s, $_, 1 ) = 1; $s; } 0 .. 9 );
my %_Ds = ( map { $_Ds[$_] => $_ } keys(@_Ds) );

sub go
{
    my ( $_n, $_d ) = @_;

    if ( !@$_n )
    {
        my @digits = ( map { $_Ds{$_} } @$_d );
        if ( all { defined($_) } @digits )
        {
            print "Number == ", (@digits), "\n";
            exit(0);
        }
        else
        {
            die "Foobar.";
        }
    }

    my $first = shift(@$_n);

    my $count = 0;
    my $v     = $first;
    my @set   = ( grep { vec( $v, $_, 8 ) < 10 } 0 .. $L );
    my $iter  = Algorithm::ChooseSubsets->new(
        set  => \@set,
        size => vec( $first, $T, 8 ),
    );

SUBSETS:
    while ( my $q = $iter->next() )
    {
        my $c = '';
        vec( $c, $_, 1 ) = 1 foreach @$q;

        # my %c = (map { $_ => undef() } @$q);
        my @n = @$_n;
        my @d = @$_d;

        foreach my $i (@set)
        {
            my $digit = vec( $v, $i, 8 );

            my $mark = sub {

                # True digit
                my ($td) = @_;

                $d[$i] = $_Ds[$td];

                foreach my $num (@n)
                {
                    # found digit
                    my $fd = vec( $num, $i, 8 );
                    if ( $fd eq $Y )
                    {
                        return 1;
                    }
                    elsif ( $fd ne $N )
                    {
                        my $is_right = ( $fd eq $td );
                        vec( $num, $i, 8 ) = ( $is_right ? $Y : $N );
                        if ($is_right)
                        {
                            if ( vec( $num, $T, 8 ) == 0 )
                            {
                                return 1;
                            }
                            vec( $num, $T, 8 )--;
                        }
                        if ( ( --vec( $num, $R, 8 ) ) < vec( $num, $T, 8 ) )
                        {
                            return 1;
                        }
                    }
                }

                return;
            };

            if ( vec( $c, $i, 1 ) )
            {
                if ( $mark->($digit) )
                {
                    next SUBSETS;
                }
            }
            else
            {
                vec( $d[$i], $digit, 1 ) = 0;
                if ( defined( my $k = $_Ds{ $d[$i] } ) )
                {
                    if ( $mark->($k) )
                    {
                        next SUBSETS;
                    }
                }
                else
                {
                    foreach my $num (@n)
                    {
                        if ( vec( $num, $i, 8 ) eq $digit )
                        {
                            vec( $num, $i, 8 ) = $N;
                            if ( ( --vec( $num, $R, 8 ) ) < vec( $num, $T, 8 ) )
                            {
                                next SUBSETS;
                            }
                        }
                    }
                }
            }
        }

        # print "Depth $depth ; Count=@{[$count++]}\n";
        go(
            [
                sort {
                    $_nC2[ vec( $a, $TR, 16 ) ] <=> $_nC2[ vec( $b, $TR, 16 ) ]
                } @n
            ],
            \@d,
        );
    }

    return;
}

package main;

my $string = <<'EOF';
5616185650518293 ;2 correct
3847439647293047 ;1 correct
5855462940810587 ;3 correct
9742855507068353 ;3 correct
4296849643607543 ;3 correct
3174248439465858 ;1 correct
4513559094146117 ;2 correct
7890971548908067 ;3 correct
8157356344118483 ;1 correct
2615250744386899 ;2 correct
8690095851526254 ;3 correct
6375711915077050 ;1 correct
6913859173121360 ;1 correct
6442889055042768 ;2 correct
2321386104303845 ;0 correct
2326509471271448 ;2 correct
5251583379644322 ;2 correct
1748270476758276 ;3 correct
4895722652190306 ;1 correct
3041631117224635 ;3 correct
1841236454324589 ;3 correct
2659862637316867 ;2 correct
EOF

my @init_n = (
    map {
        my $l = $_;
        $l =~ /\A(\d+)/ or die "Foo";
        my $row = [ split //, $1 ];
        my $row_b = '';
        while ( my ( $i, $v ) = each(@$row) )
        {
            vec( $row_b, $i, 8 ) = $v;
        }
        my ($count_correct) = $l =~ /;(\d)/ or die "Bar";
        vec( $row_b, $T, 8 ) = $count_correct;
        vec( $row_b, $R, 8 ) = $COUNT_DIGITS;
        $row_b
        }
        split( /\n/, $string )
);

my @digits;
{
    my $s = '';
    vec( $s, $_, 1 ) = 1 for 0 .. 9;
    @digits = map { $s } 0 .. $L;
}

my $init_n_sorted =
    [ sort { $_nC2[ vec( $a, $TR, 16 ) ] <=> $_nC2[ vec( $b, $TR, 16 ) ] }
        @init_n ];

go(
    # \@init_n,
    $init_n_sorted,
    \@digits,
);

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
