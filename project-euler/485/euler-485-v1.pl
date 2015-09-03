#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Tree::AVL;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my ($MAX, $STEP, $DISPLAY_STEP) = @ARGV;

my $tree = Tree::AVL->new(
    fcompare => sub {
        my ($A, $B) = @_;
        return ($A->{v} <=> $B->{v}
                or
            $A->{n} <=> $B->{n})
    },
    fget_key => sub {
        return shift->{v};
    },
    fget_data => sub {
        return shift->{n};
    },
);

my @queue;

open my $fh, sprintf("seq 1 '%d' | xargs factor |", $MAX+1);

my $sum = 0;

sub add
{
    my $l = <$fh>;
    chomp($l);
    my %f;
    my @f = $l =~ /([0-9]+)/g;
    my $n = shift(@f);
    my $val = 1;
    for my $i (@f)
    {
        $f{$i}++;
    }
    for my $x (values%f)
    {
        $val *= (1+$x);
    }

    my $rec = { n => $n, v => $val };
    push @queue, $rec;
    $tree->insert($rec);

    return;
}

for my $i (1 .. $STEP)
{
    add();
}

sub update
{
    $sum += $tree->largest()->{v};
    return;
}

update();
for my $n ($STEP+1 .. $MAX)
{
    $tree->delete(shift @queue);
    add();
    update();
    if ($n % $DISPLAY_STEP == 0)
    {
        print "Reached $n : Sum = $sum\n";
    }
}
print "Final Sum = $sum\n";
