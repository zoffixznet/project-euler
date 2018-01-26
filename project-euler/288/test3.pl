use strict;
use warnings;

use integer;
use bytes;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

use lib '.';
use Euler288 qw(factorial_factor_exp);
use Math::BigInt lib => "GMP";

my @t_n;

my $N_LIM = 20;
my $BASE  = 3;
my $LIM   = 10_000;

my $S_0 = 290797;
my $s   = $S_0;

for my $n ( 0 .. $N_LIM - 1 )
{
    push @t_n, ( $s % $BASE );
    $s = ( ( $s * $s ) % 50515093 );
}

my $sum = 0;
for my $n ( $N_LIM .. $LIM )
{
    $sum += ( $s % $BASE );
    $s = ( ( $s * $s ) % 50515093 );
}

sub f
{
    return factorial_factor_exp( shift(), Math::BigInt->new($BASE) )
        % ( Math::BigInt->new($BASE)**$N_LIM );
}

print sum( ( map { f( Math::BigInt->new($BASE)**$_ ) * $t_n[$_] } 1 .. $#t_n ),
    $sum * f( Math::BigInt->new($BASE)**$N_LIM ) )
    % ( Math::BigInt->new($BASE)**$N_LIM );
print "\n";
exit(0);

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
