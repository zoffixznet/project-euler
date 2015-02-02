#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Data::Dumper;

use List::Util qw(sum);
use List::MoreUtils qw(any none);

STDOUT->autoflush(1);

my @Graph;
foreach my $inputs (0 .. (2**6-1))
{
    my ($aa, $bb, $cc, $dd, $ee, $ff) = split//, sprintf"%06b", $inputs;
    my $new = eval ("0b$bb$cc$dd$ee$ff" . (($aa ^ ($bb & $cc)) ? '1' : '0'));
    push @{$Graph[$inputs]}, $new;
    push @{$Graph[$new]}, $inputs;
}

foreach my $node (@Graph)
{
    $node = [sort { $a <=> $b } @$node];
}

sub recurse
{
    my ($queue, $state) = @_;

    print "Q==@$queue\n";
    if (!@$queue)
    {
        return 1;
    }

    my ($inputs, @newQ) = @$queue;

    my @newS = @$state;
    $newS[$inputs] = 0;

    my $ret = recurse((\@newQ), \@newS);

    if (none { $state->[$_] == 1 } @{$Graph[$inputs]})
    {
        $newS[$inputs] = 1;
        $ret += recurse((\@newQ), \@newS);
    }

    return $ret;
}

# Find Fully-connected components (FCCs).

my @FCCs = ([]);

my %to_traverse = (map { $_ => 1 } keys @Graph);

foreach my $inputs (0 .. (2**6-1))
{
    my @q = ($inputs);
    while (defined  ( my $i = shift(@q)) )
    {
        if (exists($to_traverse{$i}))
        {
            delete $to_traverse{$i};
            push @{$FCCs[-1]}, $i;
            push @q, @{$Graph[$i]};
        }
    }

    if (@{$FCCs[-1]})
    {
        $FCCs[-1] = [ sort { $a <=> $b } @{$FCCs[-1]} ];
        push @FCCs, []
    }
}

if (! @{$FCCs[-1]})
{
    pop(@FCCs);
}

my $result = 1;

foreach my $fcc (@FCCs)
{
    my @state = ((-1) x 64);
    $state[63] = 0;
    $result *= recurse([grep { $_ != 63 } @$fcc], \@state);
}

print "Result == $result\n";
# print Dumper ([ \@FCCs ] )
