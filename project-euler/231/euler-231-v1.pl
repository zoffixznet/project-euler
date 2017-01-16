#!/usr/bin/perl

use strict;
use warnings;
use autodie;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

open my $numer_fh, '<', 'factors-15M-to-20M.txt';
open my $denom_fh, '<', 'factors-2-to-5M.txt';

my (%f);

sub read_n
{
    my $factors = <$numer_fh>;
    chomp($factors);
    $factors =~ s#\A[0-9]+: *##;
    foreach my $f ( split( / /, $factors ) )
    {
        $f{$f}++;
    }
}

sub read_d
{
    my $factors = <$denom_fh>;
    chomp($factors);
    $factors =~ s#\A[0-9]+: *##;
    foreach my $f ( split( / /, $factors ) )
    {
        $f{$f}--;
    }
}

while ( !eof($numer_fh) and !eof($denom_fh) )
{
    read_n();
    read_d();
}

while ( !eof($numer_fh) )
{
    read_n();
}
while ( !eof($denom_fh) )
{
    read_d();
}
close($numer_fh);
close($denom_fh);

my $sum = 0;

while ( my ( $f, $c ) = each(%f) )
{
    if ( $c < 0 )
    {
        die "Factor $f is $c!";
    }
    $sum += $f * $c;
}

print "Sum = $sum\n";
