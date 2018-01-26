#!/usr/bin/perl

use strict;
use warnings;
no warnings 'portable';

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(min sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

# Powers of ten.
my @P10 = (1);
for my $x ( 1 .. 100 )
{
    push @P10, ( $P10[-1] * 10 );
}

package Nexter;

sub new
{
    my ( $class, $args ) = @_;
    return bless $args, shift;
}

sub next
{
    my $self = shift;

    my $ret = sprintf( "%0" . $self->[0] . 'd', ( $self->[1]++ ) );

    if ( $self->[1] == $P10[ $self->[0] ] )
    {
        $self->[0]++;
        $self->[1] = 0;
    }

    return $ret;
}

package main;

sub test_nexter
{
    my ( $num_digits, $base, $ret1, $ret2 ) = @_;

    my $obj = Nexter->new( [ $num_digits, $base ] );

    if ( $obj->next ne $ret1 )
    {
        die "Nexter ret1: @_";
    }
    if ( $obj->next ne $ret2 )
    {
        die "Nexter ret2: @_";
    }

    return;
}

test_nexter( 1, 9,  '9',  '00' );
test_nexter( 1, 0,  '0',  '1' );
test_nexter( 2, 0,  '00', '01' );
test_nexter( 2, 99, '99', '000' );

my ( $n, $MAX_COUNT ) = @ARGV;

my $next_mins = 1;
my @mins =
    ( { s => '', strs => { next => Nexter->new( [ 0, 0 ] ), s => '', } } );

my @s_pos = ( grep { substr( $n, $_, 1 ) ne '0' } ( 1 .. length($n) - 1 ) );
my %mm = ( map { $_ => +{ next => Nexter->new( [ 0, 0 ] ), s => '' } } @s_pos );
my %mm_all_9s = ( map { $_ => +{ c => 1, p => undef(), } } @s_pos );

{
    my @c = ( undef(), 1 );

    sub start_10
    {
        my $l = shift;
        return $c[$l] //= do
        {
            ( $l - 1 ) * ( 9 * $P10[ $l - 2 ] ) + start_10( $l - 1 );
        };
    }
}

sub calc_start
{
    my $needle = shift;

    if ( $needle =~ /\A0/ )
    {
        die "<$needle>";
    }

    my $len = length($needle);

    return start_10($len) + ( $needle - $P10[ $len - 1 ] ) * $len;
}

sub test_calc_start
{
    my ( $needle, $want_pos ) = @_;

    my $have_pos = calc_start($needle);
    if ( $have_pos != $want_pos )
    {
        die "For needle=$needle got $have_pos instead of $want_pos";
    }
}

test_calc_start( 1,    1 );
test_calc_start( 2,    2 );
test_calc_start( 10,   10 );
test_calc_start( 11,   12 );
test_calc_start( 99,   10 + ( 99 - 10 ) * 2 );
test_calc_start( 100,  10 + ( 100 - 10 ) * 2 );
test_calc_start( 200,  10 + ( 100 - 10 ) * 2 + ( 200 - 100 ) * 3 );
test_calc_start( 1000, 10 + ( 100 - 10 ) * 2 + ( 1000 - 100 ) * 3 );

my @seq_poses;

sub _seq_cl
{
    shift(@seq_poses);
    return;
}

{
    my %p;
    my $len = length($n);
    for my $item_l ( 1 .. $len )
    {
    START_POS:
        for my $start_pos ( 0 .. $item_l - 1 )
        {
            if ( substr( $n, $start_pos, 1 ) eq '0' )
            {
                next START_POS;
            }
            my $s = my $init_s = substr( $n, $start_pos, $item_l );
            if ( $start_pos > 0 )
            {
                my $prev = $s - 1;
                if (
                    substr( $n, 0, $start_pos ) ne substr( $prev, -$start_pos )
                    )
                {
                    next START_POS;
                }
            }
            my $pos    = $start_pos + length($s);
            my $next_s = $s + 1;
            while ( $pos <= $len - length($next_s) )
            {
                if ( substr( $n, $pos, length($next_s) ) eq $next_s )
                {
                    $pos += length($next_s);
                    $next_s++;
                }
                else
                {
                    next START_POS;
                }
            }

            if ( $pos < $len )
            {
                if ( substr( $next_s, 0, $len - $pos ) ne substr( $n, $pos ) )
                {
                    next START_POS;
                }
            }

            # Let's rock and roll.
            $p{ calc_start($init_s) - $start_pos } = 1;
        }
    }

    for my $l ( 1 .. $len - 1 )
    {
        my $prefix = substr( $n, 0, $l );
        my $suffix = substr( $n, -$l );

        if ( $prefix eq $suffix )
        {
            for my $ml ( 0 .. $len - $l )
            {
                my $p = substr( $n, -$ml - $l );
                if ( $p !~ /\A0/ )
                {
                    for my $el ( 0 .. $len - $l )
                    {
                        my $e      = substr( $n, $l, $el );
                        my $needle = $p . $e;
                        my $offset = $ml;
                        if (
                            substr(
                                ($needle) . ( $needle + 1 ), $offset,
                                length($n)
                            ) eq $n
                            )
                        {
                            $p{ calc_start($needle) + $offset } = 1;
                        }
                    }
                }
            }
        }
    }

    for my $p ( 0 .. $len - 2 )
    {
        if ( substr( $n, $p, 1 ) eq '9' )
        {
            my $suffix = substr( $n, 0, $p + 1 );
            my $prefix = substr( $n, $p + 1 ) - 1;

            if ( $prefix > 0 )
            {
                for my $common ( 0 .. min( length($prefix), length($suffix) ) )
                {
                    my $pref_suf = substr( $prefix, length($prefix) - $common );
                    my $suf_pref = substr( $suffix, 0, $common );

                    if ( $pref_suf eq $suf_pref )
                    {
                        my $needle =
                              substr( $prefix, 0, length($prefix) - $common )
                            . $pref_suf
                            . substr( $suffix, $common );

                        my $both = $needle . ( $needle + 1 );

                        my $start = calc_start($needle);

                        for my $x (
                            map { $start + $_ }
                            grep { substr( $both, $_, length($n) ) eq $n }
                            ( 0 .. length($both) - length($n) )
                            )
                        {
                            $p{$x} = 1;
                        }
                    }
                }
            }
        }
    }

    @seq_poses = sort { $a <=> $b } keys(%p);
}

my $last_pos = 0;
my $count    = 1;

my $count_9s = 1;

my $is_count_9s;
my $c9_pos;
my $c9_count_9s_in_n;

sub _c9_cl
{
    $c9_pos = undef;
    $count_9s++;

    return;
}

my $count_9s_base;
my $c9_foo;

if ( ( $c9_foo, $count_9s_base ) = ( $n =~ /\A(9+)([^0]0*)\z/ ) )
{
    $c9_count_9s_in_n = length($c9_foo);
    $is_count_9s      = 1;
}

sub _calc_mid_val
{
    my ( $start_new_pos, $middle ) = @_;

    my $prefix = substr( $n, $start_new_pos );
    my $suffix = substr( $n, 0, $start_new_pos );

    for my $p ( grep { $_ > 0 } $prefix, $prefix - 1 )
    {
        my $needle = $p . $middle . $suffix;
        my $offset = length($p) + length($middle);

        if (
            substr( ( $needle . ( $needle + 1 ) ), $offset, length($n) ) eq $n )
        {
            return calc_start($needle) + $offset;
        }
    }

    return -1;
}

while ( $count <= $MAX_COUNT )
{
    # Int max.
    my $min = 0x7FFF_FFFF_FFFF_FFFF;

    # Cleanup handler.
    my $cl;

    # Set.
    my $s = sub {
        my ( $p, $cb ) = @_;

        if ( $p < $min )
        {
            $min = $p;
            $cl  = $cb;
            return 1;
        }
        return;
    };

    if (@seq_poses)
    {
        $s->( $seq_poses[0], \&_seq_cl );
    }

    {
        my $last_i;

        while ( my ( $i, $rec ) = each @mins )
        {
            my $r = $rec->{strs};
            if (
                $s->(
                    $r->{p} //=
                        do
                    {

                        my $prefix = $rec->{'s'};
                        my $suffix = $r->{'s'};

                        my $needle = $prefix . $n . $suffix;

                        calc_start($needle) + length($prefix);
                    },
                    sub {
                        $r->{'s'} = $r->{'next'}->next;
                        $r->{'p'} = undef;

                        return;
                    }
                )
                )
            {
                $last_i = $i;
            }
        }

        if ( defined($last_i) && ( $last_i == $#mins ) )
        {
            push @mins,
                +{
                s    => ( $next_mins++ ),
                strs => { next => Nexter->new( [ 0, 0 ] ), s => '' }
                };
        }

    }

    for my $start_new_pos (@s_pos)
    {
        {
            my $rec = $mm{$start_new_pos};

            # So we want to do:
            #
            # N = XXXYYY
            #
            # Find:
            # YYYMMMMXXX,YYY[MMMMXXX+1]
            #
            # Now if XXX !~ /9\z/ then everything is peachy.
            #
            # But what if it is?
            #
            # if MMMXXX =~ /[0-8]9\z/ then [MMMXXX+1] =~ /[1-9]0\z/ so it will
            # still will not overflow.
            #
            # So what happens if MMMXXX is all-9s?
            #
            # We need:
            # [YYY-1]MMMXXX,YYY[00000000]
            $s->(
                ( $rec->{p} //= _calc_mid_val( $start_new_pos, $rec->{'s'} ) ),
                sub {
                    $rec->{'s'} = $rec->{'next'}->next;
                    $rec->{'p'} = undef;

                    return;
                }
            );
        }

        {
            my $rec = $mm_all_9s{$start_new_pos};

            if ( $rec->{'c'} < 30 )
            {

              # So we want to do:
              #
              # N = XXXYYY
              #
              # Find:
              # YYYMMMMXXX,YYY[MMMMXXX+1]
              #
              # Now if XXX !~ /9\z/ then everything is peachy.
              #
              # But what if it is?
              #
              # if MMMXXX =~ /[0-8]9\z/ then [MMMXXX+1] =~ /[1-9]0\z/ so it will
              # still will not overflow.
              #
              # So what happens if MMMXXX is all-9s?
              #
              # We need:
              # [YYY-1]MMMXXX,YYY[00000000]
                $s->(
                    (
                        $rec->{p} //=
                            _calc_mid_val( $start_new_pos, '9' x $rec->{'c'} )
                    ),
                    sub {
                        $rec->{c}++;
                        $rec->{p} = undef;

                        return;
                    }
                );
            }
        }
    }

    if ($is_count_9s)
    {
    COUNT9:
        while ( !defined $c9_pos )
        {
            my $c9         = $count_9s_base . '0' x $count_9s;
            my $c9_minus_1 = $c9 - 1;
            my $both       = $c9_minus_1 . $c9;
            if ( $both =~ /\Q$n\E/ )
            {
                my $offset = length($c9_minus_1) - $c9_count_9s_in_n;
                $c9_pos = calc_start($c9_minus_1) + $offset;
                last COUNT9;
            }
        }
        continue
        {
            $count_9s++;
        }
        $s->( $c9_pos, \&_c9_cl );
    }

    $cl->();
    if ( $min > $last_pos )
    {
        print "$min\n";
        $count++;
        $last_pos = $min;
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
