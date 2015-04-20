#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use List::Util qw(sum);
use List::MoreUtils qw();

use DB_File;

STDOUT->autoflush(1);

my %cache;

tie %cache, 'DB_File', 'e306.db';

my $THIS_PLAYER = 1;
my $OTHER_PLAYER = 2;

my $THIS_PLAYER_WINS = 1;
my $OTHER_PLAYER_WINS = 2;

$cache{'2'} = $THIS_PLAYER_WINS;

sub evl
{
    my ($key) = @_;

    my $str = join(",",@$key);
    if (exists($cache{$str}))
    {
        return $cache{$str};
    }
    else
    {
        my $val = sub {
            for my $i (keys @$key)
            {
                my $len = $key->[$i];
                my @head = @$key[0 .. $i-1];
                my @tail = @$key[$i+1 .. $#$key];

                # k[i] = 2 => 0
                # k[i] = 3 => 0
                # k[i] = 4 => 1
                # k[i] = 5 => 1
                # k[i] = 6 => 2
                # k[i] = 7 => 2 [  XX   ]
                for my $start (0 .. (($len>>1)-1) )
                {
                    my @parts = (grep { $_ >= 2 } ($start, $len-$start-2));
                    my @new_key = (@head, (sort {$b <=> $a} @tail, @parts));
                    if (evl(\@new_key) == $OTHER_PLAYER_WINS)
                    {
                        return $THIS_PLAYER_WINS;
                    }
                }
            }
            return $OTHER_PLAYER_WINS;
        }->();

        $cache{$str} = $val;

        if ($val == $OTHER_PLAYER_WINS)
        {
            for my $i (keys @$key)
            {
                my @head = @$key[0 .. $i-1];
                my @tail = @$key[$i+1 .. $#$key];
                for my $l (2 .. 3)
                {
                    $cache{join(",",
                            sort { $b <=> $a } @head, @tail, $key->[$i]+$l
                        )
                    } = $THIS_PLAYER_WINS;
                }
            }
            for my $l (2 .. 4)
            {
                $cache{join(",",
                        sort { $b <=> $a } @$key, $l
                    )
                } = $THIS_PLAYER_WINS;
            }
        }

        return $val;
    };
}

my $count = 1;

my $MAX = 50;

for my $n (3 .. $MAX)
{
    if (evl([$n]) == $THIS_PLAYER_WINS)
    {
        $count++;
    }
    print "Reached $n ; Got $count\n";
}
