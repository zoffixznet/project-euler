#!/usr/bin/perl

use strict;
use warnings;
use lib '.';

use 5.016;

no warnings 'recursion';

use Euler_463_v2;

my $MOD = 1_000_000_000;

sub _cache
{
    my ( $h, $key, $promise ) = @_;

    my $ret = $h->{$key};

    if ( !defined($ret) )
    {
        $ret = $promise->();
    }
    $h->{$key} = $ret;

    return $ret;
}

my %cache;

sub f_mod
{
    my ($n) = @_;

    if ( $n < 1 )
    {
        die "Foo";
    }

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
                my $power2 = (
                    ( ( $start & ( $start - 1 ) ) != 0 )
                    ? 1 + ( ( $start - 1 ) ^ $start )
                    : $start
                );
                my $new_end = $start + $power2 - 1;
                while ( $new_end > $end )
                {
                    $new_end = $start + ( $power2 >>= 1 ) - 1;
                }
                my @c = Euler_463_v2->new->lookup($power2);
                my $m = $start / $power2;
                return (
                    (
                        $c[0] * f_mod( $m * 2 + 1 ) +
                            $c[1] * f_mod($m) +
                            s_smart( $new_end + 1, $end )
                    ) % $MOD
                );
            },
        );
    }
}

if ( $ENV{TEST} )
{
    my $want = 0;
    foreach my $n ( 1 .. 100_000 )
    {
        if ( $n % 1_000 == 0 )
        {
            say "Reached n=$n";
        }
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
