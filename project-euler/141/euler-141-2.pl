#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt lib => 'GMP';

STDOUT->autoflush(1);

my %squares = ( map { $_ * $_ => undef() } 1 .. 999_999 );

# my $sum = 0;

my $d;
my $d3;
my $factors;

sub divisors
{
    my ( $r, $this_ ) = @_;
    if ( $this_ == @$factors )
    {
        my $n = ( $r + $d3 / $r );

        if ( exists( $squares{$n} ) )
        {
            if ( $n % $d == $r )
            {
                my @i = sort { $a <=> $b } ( int( $n / $d ), $d, $r );
                if ( Math::BigInt->new( $i[1] ) * Math::BigInt->new( $i[1] ) ==
                    Math::BigInt->new( $i[0] ) * Math::BigInt->new( $i[2] ) )
                {
                    print "Found for d=$d r=$r q=@{[int($n/$d)]} n=$n\n";
                }
            }
        }
    }
    else
    {
        my ( $b, $e ) = @{ $factors->[$this_] };
        my $rest = $this_ + 1;

    I:
        for my $i ( 0 .. $e )
        {
            if ( $r >= $d )
            {
                last I;
            }
            divisors( $r, $rest );
            $r *= $b;
        }
    }
    return;
}

open my $fh, '<', 'factors.txt';
for my $i ( 2 .. 999_999 )
{
    $d = $i;
    if ( $d % 1_000 == 0 )
    {
        print "D=$d\n";
    }

    # my $d3 = Math::BigInt->new($d) * $d * $d;
    $d3 = $d * $d * $d;
    my %f;
    my @x = split /\s+/, <$fh>;
    pop(@x);
    foreach my $f (@x)
    {
        $f{$f} += 3;
    }

    $factors = [ map { [ $_, $f{$_} ] } keys(%f) ];
    divisors( 1, 0 );
}

close($fh);

# print "sum = $sum\n";

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
