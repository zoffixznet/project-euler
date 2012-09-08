#!/usr/bin/perl

# This is based on:
# http://eli.thegreenplace.net/2009/03/01/project-euler-problem-104/

use strict;
use warnings;

use Math::BigInt only => 'GMP', ':constant';


sub is_pan
{
    my $s = shift;
    return join("", sort { $a cmp $b } split//, $s) eq "123456789";
}

my %fib_cache = (1 => 1, 2 => 1);

sub calc_fib
{
    my ($n) = @_;
    
    return $fib_cache{$n} ||=
        (
              ($n & 0x1)
            ? do { 
                my $half = (($n-1)>>1); 
                my $x = calc_fib($half); 
                my $y = calc_fib($half+1);
                $x*$x+$y*$y;
            }
            : do { 
                my $half = ($n>>1); 
                my $x = calc_fib($half);
                my $y = calc_fib($half-1);
                $x * (($y<<1)+$x);
            }
        );
}

my $MOD = 1_000_000_000;

my $this_fib_low = 1;
my $prev_fib_low = 1;

my $k = 2;
while (1)
{
    ($prev_fib_low, $this_fib_low) = 
        ($this_fib_low, (($prev_fib_low+$this_fib_low) % $MOD));
    $k++;

    if (is_pan($this_fib_low))
    {
        if (is_pan(substr(calc_fib($k) . '', 0, 9)))
        {
            print "F_[$k] matches.\n";
            exit(0);
        }
    }
}

