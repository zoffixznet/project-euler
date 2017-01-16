#!/usr/bin/perl

use strict;
use warnings;

use integer;

use IO::Handle;

STDOUT->autoflush(1);

=head1 ANALYSIS

(z+2d)^2 - (z+d)^2 - z^2 = z^2+4dz+4d^2 - z^2 - 2dz - d^2 - z^2 =
-z^2 + 2dz +3d^2 = (-z + 3d)(z + d)

=cut

my $solution_counts_vec = '';
my $ten_counts          = 0;

my $LIMIT = 50_000_000;

foreach my $z ( 1 .. ( $LIMIT - 1 ) )
{
    print "Z = $z ; Ten Counts = $ten_counts\n" if ( $z % 10_000 == 0 );
    my $d = ( int( $z / 3 ) + 1 );

D_LOOP:
    while (1)
    {
        my $n = ( 3 * $d - $z ) * ( $z + $d );

        if ( $n >= $LIMIT )
        {
            last D_LOOP;
        }
        elsif ( $n > 0 )
        {
            my $c = vec( $solution_counts_vec, $n, 2 );
            $c++;
            if ( $c == 2 )
            {
                $ten_counts--;
            }
            elsif ( $c == 3 )
            {
                # Make sure it doesn't overflow.
                $c--;
            }
            elsif ( $c == 1 )
            {
                $ten_counts++;
            }
            vec( $solution_counts_vec, $n, 2 ) = $c;
        }
    }
    continue
    {
        $d++;
    }
}

print "Ten counts = $ten_counts\n";
