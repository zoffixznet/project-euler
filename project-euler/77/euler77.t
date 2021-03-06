use strict;
use warnings;

use Test::More tests => 5;

use Euler77;

# TEST
is( get_num_primes_combinations(2), 1, "2 == { [2] }" );

# TEST
is( get_num_primes_combinations(3), 1, "3 == { [3] }" );

# TEST
is( get_num_primes_combinations(4), 1, "4 == { [2,2] }", );

# TEST
is( get_num_primes_combinations(5), 2, "4 == { [2,3], [5] }", );

# TEST
is(
    get_num_primes_combinations(10),
    5, "10 == {[7,3], [5, 5], [5, 3, 2], [3, 3, 2, 2], [2, 2, 2, 2, 2]}",
);

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
