#!/usr/bin/perl

use strict;
use warnings;
use autodie;

use 5.016;

use integer;
use bytes;

=head1 DESCRIPTION

Let f(n) be the largest positive integer x less than 109 such that the last 9 digits of nx form the number x (including leading zeros), or zero if no such integer exists.

For example:

    f(4) = 411728896 (4411728896 = ...490411728896)
    f(10) = 0
    f(157) = 743757 (157743757 = ...567000743757)
    Σf(n), 2 ≤ n ≤ 103 = 442530011399

Find Σf(n), 2 ≤ n ≤ 106.

=cut

my $MOD = 1_000_000_000;

sub exp_mod
{
    my ($b, $e) = @_;

    if ($e == 0)
    {
        return 1;
    }

    my $rec_p = exp_mod($b, ($e >> 1));

    my $ret = $rec_p * $rec_p;

    if ($e & 0x1)
    {
        $ret *= $b;
    }

    return ($ret % $MOD);
}

# my $START = $MOD-1;
my $START = 999997951;
my $SEGMENT = 1024;

my $DUMP_FN =  'euler-455.txt';

my $sum = 0;
# Every n^e where e > 2 will have more zeros than needed.
my @n_s = (grep { $_ % 10 != 0 } (2 .. 1_000_000));

{
    my %blacklist;
    open my $in, '<', $DUMP_FN;
    while (my $l = <$in>)
    {
        chomp($l);
        if (my ($x, $n) = $l =~ /\AFound x=(\d+) for n=(\d+)\z/)
        {
            $sum += $x;
            $blacklist{$n} = 1;
        }
        elsif (my ($reached) = $l =~ /\AInspecting (\d+)/)
        {
            $START = $reached;
        }
    }
    close($in);

    @n_s = grep { !exists($blacklist{$_}) } @n_s;
}

STDOUT->autoflush(1);

my $range_top = $START;

open my $out_fh, '>>', $DUMP_FN;
$out_fh->autoflush(1);
while ($range_top > $SEGMENT)
{
    say {$out_fh} "Inspecting $range_top";
    my $bottom = $range_top - ($SEGMENT - 1);

    my @next_n_s;
    for my $n (@n_s)
    {
        my $e = $bottom;
        my $m = exp_mod($n, $e);
        my $found_e;
        while ($e <= $range_top)
        {
            if ($m == $e)
            {
                $found_e = $e;
            }
            $m = (($m * $n) % $MOD);
        }
        continue
        {
            $e++;
        }

        if (defined($found_e))
        {
            say {$out_fh} "Found x=$found_e for n=$n";
            $sum += $found_e;
        }
        else
        {
            push @next_n_s, $n;
        }
    }
    @n_s = @next_n_s;
}
continue
{
    $range_top -= $SEGMENT;
}
close($out_fh);
say "Sum == $sum";


__END__

=begin FOO

sub func
{
    my ($n) = @_;

    my $e = 1;
    my $m = $n;

    my $found_e;

    while (($e < $MOD) && ($m != 1))
    {
        print "E=$e M=$m\n";
        if ($m == 0)
        {
            return 0;
        }
        elsif ($m == $n)
        {
            $found_e = $e;
        }
    }
    continue
    {
        $e++;
        $m = (($m * $n) % $MOD);
    }

    if ($e == $MOD or (!defined($found_e)))
    {
        return 0;
    }
    else
    {
        my $div = ($MOD / $e);
        my $mod = ($MOD % $e);

        return (($div - ($mod > $found_e)) *$e + $found_e);
    }
}

=end FOO

=cut
