#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt ( try => 'GMP' );
use 5.016;

my @results;
my $sum       = Math::BigInt->new('0');
my $num_found = 0;
my $MIN       = 2;
my $MAX       = 1_000_000;

while (<>)
{
    chomp;
    if ( my ( $n, $result ) = /\Af\((\d+)\) == (\d+)\z/ )
    {
        if ( $n >= $MIN and $n <= $MAX )
        {
            if ( !defined( $results[$n] ) )
            {
                $results[$n] = $result;
                $sum += $result;
                $num_found++;
            }
            elsif ( $results[$n] != $result )
            {
                die "f[$n] is both $result and $results[$n]!";
            }
        }
    }
}

if ( $num_found == $MAX - $MIN + 1 )
{
    say "Sum == $sum\n";
}
else
{
    die "Could only found $num_found.";
}

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
