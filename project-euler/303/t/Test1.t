#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 6;

use Euler303_Take1 (qw( f_div f_complete ));

{

    # TEST
    is( f_complete(2), 2, "f_complete for 2" );

    # TEST
    is( f_complete(3), 12, "f_complete for 3" );

    # TEST
    is( f_complete(7), 21, "f_complete for 7" );

    # TEST
    is( f_complete(42), 210, "f_complete for 42" );

    # TEST
    is( f_complete(89), 1121222, "f_complete for 89" );

    # TEST
    is( f_complete(9_999), '11112222222222222222', "f_complete for 9_999" );
}

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
