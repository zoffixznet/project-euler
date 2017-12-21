#!/usr/bin/perl

use strict;
use warnings;

STDOUT->autoflush(1);

my $LIM = 10_000_000;

my $sum = 0;

my %mod5_blacklist = ( map { $_ => 1 } ( 0, 1, 4 ) );

# Filter out all the primes whose modulo with 3 is 2, because they cannot
# match both expressions based on modulo analysis for that modulo.
my $primes_sqs = [
    map { $_ * $_ }
        grep {
        not( ( $_ % 3 == 2 ) || ( exists( $mod5_blacklist{ $_ % 5 } ) ) )
        } `primes 2 $LIM`
];

my $n = 1;
while ( @$primes_sqs > 0 )
{
    my $next_primes_sqs = [];
    my $f_n = $n * ( $n - 3 ) - 1;

    my $count = @$primes_sqs;

    foreach my $p_sq (@$primes_sqs)
    {
        if ( $f_n % $p_sq == 0 )
        {
            print "Found R(", sqrt($p_sq), ") == $n\n";
            print "Remaining: ", ( --$count ), "\n";
            $sum += $n;
        }
        else
        {
            push @$next_primes_sqs, $p_sq;
        }
    }

    $primes_sqs = $next_primes_sqs;
    $n++;
}

print "Sum == $sum\n";

=head1 COPYRIGHT & LICENSE

Copyright 2017 by Shlomi Fish

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
