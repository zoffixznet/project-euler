use strict;
use warnings;
use integer;

use feature qw/ say /;
use List::Util qw/ max /;

sub factor
{
    my ($n) = @_;
    my $r;
    my $f;
    while ( ( $n & 1 ) == 0 )
    {
        $f = 1;
        $n >>= 1;
    }
    if ($f)
    {
        $r = 2;
    }
    my $l = int sqrt $n;
    my $d = 3;
    while ( $d <= $l )
    {
        $f = 0;
        while ( $n % $d == 0 )
        {
            $n /= $d;
            $f = 1;
        }
        if ($f)
        {
            $r = $d;
            $l = int sqrt $n;
        }
        $d += 2;
    }
    return $n > 1 ? $n : $r;
}

my $s = 1;

# for 2 .. 20_000 -> Int $k {
for my $k ( 2 .. 2_000_000 )
{
    $s += max map { factor($_) } $k + 1, ( $k * $k - $k + 1 );
    say "$k : $s" if $k % 1_000 == 0;
}
say "Result = $s";
