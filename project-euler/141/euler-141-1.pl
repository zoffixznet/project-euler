#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(first);

STDOUT->autoflush(1);

my $sum = 0;

N:
for my $n_root ( 1 .. ( 1_000_000 - 1 ) )
{
    my $n = ( $n_root * $n_root );

=begin removed
    # TODO : Remove later.
    if ($n >= 100_000)
    {
        last N;
    }
=end removed

=cut

R:
    for my $r ( 1 .. $n )
    {
        my $prod = $r * ( $n - $r );
        my $d_guess = $prod**( 1 / 3 );

        if ( $d_guess <= $r )
        {
            last R;
        }

        my $d = first { $_ * $_ * $_ == $prod }
        ( int($d_guess) - 1 .. int($d_guess) + 1 );
        if ( defined($d) )
        {
            my $q     = int( $n / $d );
            my $r_new = ( $n % $d );
            if ( $r_new == $r )
            {
                my @seq = ( sort { $a <=> $b } ( $q, $d, $r ) );
                if ( $seq[1] * $seq[1] == $seq[0] * $seq[2] )
                {
                    $sum += $n;
                    print "Found Intermediate sum[n=$n] = $sum\n";
                    last R;
                }
            }
        }
    }
    print "Intermediate sum[n_root=$n_root] = $sum\n";
}

print "Final sum = $sum\n";

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
