#!/usr/bin/perl

use strict;
use warnings;

use 5.016;

no warnings 'recursion';

my $MOD = 1_000_000_000;

my $LOWER = 100;

my $UPPER = $LOWER * 2;

sub _cache
{
    my ( $h, $key, $promise ) = @_;

    my $ret = $h->{$key};

    if ( !defined($ret) )
    {
        $ret = $promise->();
    }

    my $num_keys = scalar keys %$h;

    if ( $num_keys >= $UPPER )
    {
        my @to_del;

        my $NUM = $num_keys - $LOWER;
    K:
        while ( my ( $k, undef ) = each %$h )
        {
            push @to_del, $k;
            if ( @to_del == $NUM )
            {
                last K;
            }
        }
        delete @$h{@to_del};
    }
    $h->{$key} = $ret;

    return $ret;
}

my %cache;

sub f_mod
{
    my ($n) = @_;

    return _cache(
        \%cache,
        $n,
        sub {
            if ( $n == 1 )
            {
                return 1;
            }
            elsif ( $n == 3 )
            {
                return 3;
            }
            elsif ( ( $n & 1 ) == 0 )
            {
                return f_mod( $n >> 1 );
            }
            elsif ( ( $n & 3 ) == 1 )
            {
                return ( 2 * f_mod( ( $n >> 1 ) + 1 ) - f_mod( $n >> 2 ) )
                    % $MOD;
            }
            else
            {
                return ( 3 * f_mod( ( $n >> 1 ) ) - 2 * f_mod( $n >> 2 ) )
                    % $MOD;
            }
        }
    );
}

sub s_bruteforce
{
    my ($n) = @_;

    my $s = 0;

    foreach my $i ( 1 .. $n )
    {
        ( $s += f_mod($i) ) %= $MOD;
    }

    return $s;
}

{
    my %s_cache;

    sub s_smart
    {
        my ( $start, $end ) = @_;

        # say "s->e : $start->$end";
        return _cache(
            \%s_cache,
            "$start|$end",
            sub {
                if ( $start > $end )
                {
                    return 0;
                }
                if ( $start == $end )
                {
                    return f_mod($start);
                }
                if ( $end <= 8 )
                {
                    return s_bruteforce($end) - s_bruteforce( $start - 1 );
                }
                if ( ( $start & 0b11 ) != 0 )
                {
                    return ( ( f_mod($start) + s_smart( $start + 1, $end ) )
                        % $MOD );
                }
                if ( ( $end & 0b11 ) != 0b11 )
                {
                    return (
                        ( f_mod($end) + s_smart( $start, $end - 1 ) ) % $MOD );
                }
                my $half_start = ( $start >> 1 );
                my $half_end   = ( $end >> 1 );
                return (
                    (
                        6 * f_mod($half_end) +
                            ( s_smart( $half_start + 1, $half_end - 1 ) << 2 )
                            - ( f_mod($half_start) << 1 )
                    ) % $MOD
                );
            },
        );
    }
}

if (1)
{
    my $want = 0;
    foreach my $n ( 1 .. 1_000_000 )
    {
        ( $want += f_mod($n) ) %= $MOD;
        my $have = s_smart( 1, $n );
        if ( $want != $have )
        {
            die "want=$want have=$have n=$n!";
        }
    }
}

{
    say "S(3 ** 37) = ", s_smart( 1, ( eval join '*', (3) x 37 ) );
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
