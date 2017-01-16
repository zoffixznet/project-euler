#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use List::Util qw(sum);
use List::MoreUtils qw(all);

use DB_File;

STDOUT->autoflush(1);

my $TIED = 1;

my %cache;

if ($TIED)
{
    tie %cache, 'DB_File', 'e306.db';
}

my $THIS_PLAYER  = 1;
my $OTHER_PLAYER = 2;

my $THIS_PLAYER_WINS  = 1;
my $OTHER_PLAYER_WINS = 2;

$cache{'2'} = $THIS_PLAYER_WINS;

sub evl
{
    my ($key) = @_;

    my $str = join( ",", @$key );
    if ( exists( $cache{$str} ) )
    {
        return $cache{$str};
    }
    else
    {
        my $val = sub {

            if ( @$key == 1 and ( ( $key->[0] & 0x1 ) == 0 ) )
            {
                # The first player can partition the space in the middle
                # to two equal halves after which he becomes the second
                # player and can use the mirroring method to win.
                return $THIS_PLAYER_WINS;
            }

            if (
                ( @$key & 0x1 == 0 )
                and all { $key->[ $_ << 1 ] == $key->[ ( $_ << 1 ) | 1 ] }
                ( 0 .. @$key >> 1 )
                )
            {
                # The other player wins because he can use the mirroring
                # process to force a victory
                return $OTHER_PLAYER_WINS;
            }
            my $prev_len = -1;
            for my $i ( keys @$key )
            {
                my $len = $key->[$i];
                if ( $len != $prev_len )
                {
                    my @head = @$key[ 0 .. $i - 1 ];
                    my @tail = @$key[ $i + 1 .. $#$key ];

                    # k[i] = 2 => 0
                    # k[i] = 3 => 0
                    # k[i] = 4 => 1
                    # k[i] = 5 => 1
                    # k[i] = 6 => 2
                    # k[i] = 7 => 2 [  XX   ]
                    for my $start ( 0 .. ( ( $len >> 1 ) - 1 ) )
                    {
                        my @parts =
                            ( grep { $_ >= 2 } ( $start, $len - $start - 2 ) );
                        my @new_key =
                            ( @head, ( sort { $b <=> $a } @tail, @parts ) );
                        if ( evl( \@new_key ) == $OTHER_PLAYER_WINS )
                        {
                            return $THIS_PLAYER_WINS;
                        }
                    }
                    $prev_len = $len;
                }
            }
            return $OTHER_PLAYER_WINS;
            }
            ->();

        $cache{$str} = $val;

        if ( $val == $OTHER_PLAYER_WINS )
        {
            for my $i ( keys @$key )
            {
                my @head = @$key[ 0 .. $i - 1 ];
                my @tail = @$key[ $i + 1 .. $#$key ];
                for my $l ( 2 .. 3 )
                {
                    $cache{
                        join( ",",
                            sort { $b <=> $a } @head,
                            @tail,
                            $key->[$i] + $l )
                    } = $THIS_PLAYER_WINS;
                }
            }
            for my $l ( 2 .. 4 )
            {
                $cache{ join( ",", sort { $b <=> $a } @$key, $l ) } =
                    $THIS_PLAYER_WINS;
            }
        }

        return $val;
    }
}

my $count = 1;

my $MAX = 1_000_000;

$SIG{'INT'} = sub {
    if ($TIED)
    {
        untie %cache;
    }
    exit(-1);
};

for my $n ( 3 .. $MAX )
{
    if ( evl( [$n] ) == $THIS_PLAYER_WINS )
    {
        $count++;
    }
    print "Reached $n ; Got $count\n";
}
