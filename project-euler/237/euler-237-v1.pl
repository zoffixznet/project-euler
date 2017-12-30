#!/usr/bin/perl

use strict;
use warnings 'FATAL' => 'all';

use integer;
use bytes;

use Math::BigInt lib => 'GMP';    #, ':constant';

package SigData;

use Cpanel::JSON::XS;
my $coder = Cpanel::JSON::XS->new->canonical(1);

sub pack_
{
    return $coder->encode(shift);
}

use MooX qw/late/;

# The data.
has 'data' => ( is => 'ro', required => 1 );
has 'sig' => ( is => 'lazy' );

sub _build_sig
{
    return $coder->encode( shift->data );
}

package DataObj;

use MooX qw/late/;

has 'd' => ( is => 'ro', required => 1 );

# The values.
has 'records' => ( is => 'rw', required => 1 );

sub count
{
    my $self = shift;

    return scalar keys %{ $self->records };
}

sub place_in
{
    my ( $class, $hash, $data, $records ) = @_;

    my $obj = $class->new( { d => $data, records => $records } );
    my $sig = $obj->d->sig;
    if ( exists( $hash->{$sig} ) )
    {
        return $hash->{$sig}->records;
    }
    else
    {
        $hash->{$sig} = $obj;
        return $obj->records;
    }
}

package main;

use List::Util qw(sum);
use List::MoreUtils qw(any none indexes);

STDOUT->autoflush(1);

my %one_wide_components = (
    left   => {},
    right  => {},
    middle => {},
);

my $UP    = 0;
my $RIGHT = 1;
my $DOWN  = 2;
my $LEFT  = 3;

sub insert
{
    my ( $type, $squares ) = @_;

    my @fcc;

    my $trans = sub { my $i = shift; return [ $i, [ @{ $squares->[$i] } ] ]; };

    push @fcc, [ $trans->(0) ];
    for my $i ( 1 .. 3 )
    {
        if ( none { $_ == $UP } @{ $squares->[$i] } )
        {
            push @fcc, [];
        }
        push @{ $fcc[-1] }, $trans->($i);
    }
    if ( !@{ $fcc[-1] } )
    {
        pop(@fcc);
    }

    foreach my $f (@fcc)
    {
        @$f = ( sort { $a <=> $b } map { $_, $_ + 4 } @$f );
    }

    my $h1    = $one_wide_components{$type};
    my $d     = SigData->new( { data => $squares } );
    my $h2    = DataObj->place_in( $h1, $d, +{} );
    my $h3    = DataObj->place_in( $h2, $d, +{} );
    my $count = DataObj->place_in(
        $h3,
        SigData->new( { data => ( \@fcc ) } ),
        Math::BigInt->new('0')
    );
    $count++;

    return;
}

sub piece_dirs
{
    my ($bef) = @_;

    if ( @$bef == 4 )
    {
        my @squares = ( map { [@$_] } @$bef );
        for my $i ( 0 .. 2 )
        {
            if ( any { $_ == $DOWN } @{ $bef->[$i] } )
            {
                if ( none { $_ == $UP } @{ $bef->[ $i + 1 ] } )
                {
                    # Invalid piece.
                    return;
                }
            }
        }

        my $upper_up   = ( any { $_ == $UP } @{ $bef->[0] } );
        my $lower_down = ( any { $_ == $DOWN } @{ $bef->[-1] } );
        if ( $upper_up || $lower_down )
        {
            # Candidate for left.
            if ( $upper_up && $lower_down )
            {
                # Candidate for left.
                $squares[0]  = [ grep { $_ != $UP } @{ $squares[0] } ];
                $squares[-1] = [ grep { $_ != $DOWN } @{ $squares[-1] } ];
                if (
                    any
                    {
                        any { $_ == $LEFT } @$_
                    }
                    @squares
                    )
                {
                    return;
                }
                insert( 'left', \@squares );
            }
            return;
        }

        if (
            none
            {
                any { $_ == $RIGHT } @$_
            }
            @$bef
            )
        {
            # Candidate for right.
            insert( 'right', \@squares );

            return;
        }

        insert( 'middle', \@squares );
    }
    else
    {
        for my $low ( 0 .. 2 )
        {
            for my $high ( $low + 1 .. 3 )
            {
                piece_dirs( [ @$bef, [ $low, $high ] ] );
            }
        }
    }

    return;
}

piece_dirs( [] );

use Data::Dumper;

# print Dumper( \%one_wide_components );

my %mid;

my %C;

my @RET_NODES = qw(l0 l1 l2 l3 r4 r5 r6 r7);
my %RET_NODES_LOOKUP = ( map { $RET_NODES[$_] => $_ } keys @RET_NODES );

sub calc_ret_fcc
{
    my ( $left_fcc_sig, $right_fcc_sig, $left_r_sig, $right_l_sig ) = @_;

    return $C{ $left_fcc_sig->sig }{ $right_fcc_sig->sig }{ $left_r_sig->sig }
        { $right_l_sig->sig } //= (
        sub {
            my %fcc;

            # if ( ++$::mytrace % 10_000 == 0 )
            if ( ++$::mytrace )
            {
                print "Trace " . ($::mytrace) . "\n";
            }
            foreach my $REC ( [ 'l', $left_fcc_sig ], [ 'r', $right_fcc_sig ] )
            {
                my ( $p, $sig ) = @$REC;
                foreach my $f ( @{ $sig->data } )
                {
                    my $sub = sub { return $p . $f->[shift]; };
                    for my $i ( 0 .. $#$f )
                    {
                        for my $j ( 0 .. $#$f )
                        {
                            $fcc{ $sub->($i) }{ $sub->($j) } = 1;
                        }
                    }
                }
            }
            {
                my $l = $left_r_sig->data;
                my $r = $right_l_sig->data;

                for my $i ( 0 .. 3 )
                {
                    my $l_bool = any { $_ == $RIGHT } @{ $l->[$i] };
                    my $r_bool = any { $_ == $LEFT } @{ $r->[$i] };
                    if ( $l_bool xor $r_bool )
                    {
                        print "discord ret " . ($::mytrace) . "\n";
                        return 0;
                    }
                    if ($l_bool)
                    {
                        my $l_k = 'l' . ( $i + 4 );
                        my $r_k = 'r' . $i;
                        $fcc{$l_k}{$r_k} = $fcc{$r_k}{$l_k} = 1;
                    }
                }
            }

            my @nodes = ( map { ; "l$_", "r$_" } 0 .. 7 );
            my %found = ( map { $_ => +{ $_ => 1 } } @nodes );
            print "Flutter " . ($::mytrace) . "\n";

        FIND:
            while (1)
            {
                my $changed = 0;
                foreach my $node (@nodes)
                {
                    my %node_fcc   = %{ $found{$node} };
                    my $init_count = scalar keys %node_fcc;
                    foreach my $link ( keys( %{ $fcc{$node} } ) )
                    {
                        %node_fcc = ( %node_fcc, %{ $found{$link} } );
                    }
                    if ( scalar keys %node_fcc > $init_count )
                    {
                        $changed = 1;
                        foreach my $link ( keys(%node_fcc) )
                        {
                            $found{$link} = {%node_fcc};
                        }
                    }
                }
                if ( !$changed )
                {
                    last FIND;
                }
            }
            print "PINK " . ($::mytrace) . "\n";

            my @ret_fcc;
            foreach my $node (@RET_NODES)
            {
                if ( exists( $found{$node} ) )
                {
                    my @links = keys( %{ $found{$node} } );
                    push @ret_fcc,
                        [ sort { $a <=> $b }
                            @RET_NODES_LOOKUP{
                            grep { exists( $RET_NODES_LOOKUP{$_} ) } @links
                            } ];

                    delete @found{@links};
                }
            }
            if ( scalar keys %found )
            {
                return 0;
            }
            print "ApleJ " . ($::mytrace) . "\n";

            return SigData->new( { data => \@ret_fcc } );

        }
            ->()
        );
}

sub merge_middle
{
    my ( $left_l, $right_l ) = @_;

    my $iter1 = sub {
        my ( $h, $cb ) = @_;

        foreach my $k ( keys %$h )
        {
            my $obj = $h->{$k};

            $cb->($obj);
        }
    };

    my $iter3 = sub {
        my ( $h, $cb ) = @_;

        $iter1->(
            $h,
            sub {
                my ($l_obj) = @_;
                $iter1->(
                    $l_obj->records,
                    sub {
                        my ($r_obj) = @_;
                        $iter1->(
                            $r_obj->records,
                            sub {
                                my ($fcc_obj) = @_;
                                return $cb->( $l_obj, $r_obj, $fcc_obj, );
                            }
                        );
                    }
                );
            }
        );
    };

    my $sum     = $left_l + $right_l;
    my $sum_mid = $mid{$sum} = {};
    my $total   = Math::BigInt->new('0');

    $iter3->(
        $mid{$left_l},
        sub {
            my ( $left_l_obj, $left_r_obj, $left_fcc_obj ) = @_;
            $iter3->(
                $mid{$right_l},
                sub {
                    my ( $right_l_obj, $right_r_obj, $right_fcc_obj ) = @_;

                    my $ret_fcc = calc_ret_fcc(
                        $left_fcc_obj->d, $right_fcc_obj->d,
                        $left_r_obj->d,   $right_l_obj->d,
                    );

                    print "twil " . ($::mytrace) . "\n";
                    if ( not $ret_fcc )
                    {
                        return;
                    }

                    my $h1 = $sum_mid;
                    my $h2 = DataObj->place_in( $h1, $left_l_obj->d, +{} );
                    my $h3 = DataObj->place_in( $h2, $right_r_obj->d, +{} );
                    my $count =
                        DataObj->place_in( $h3, $ret_fcc,
                        Math::BigInt->new('0') );
                    my $delta = $left_fcc_obj->count * $right_fcc_obj->count;
                    $count += $delta;
                    $total += $delta;
                    print "crad " . ($::mytrace) . " total = $total\n";
                }
            );
        }
    );
}

$mid{1} = $one_wide_components{middle};

# my $LEN = 10 ** 12;
my $LEN = 10;

# Subtract 1 for the left and 1 for the right.
my $MIDDLE_LEN = $LEN - 2;

{
    my $l      = 1;
    my $next_l = $l << 1;
    while ( $next_l <= $MIDDLE_LEN )
    {
        print "Calling merge_middle($l,$l) → $next_l\n";
        merge_middle( $l, $l );
    }
    continue
    {
        $l = $next_l;
        $next_l <<= 1;
    }
}

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
