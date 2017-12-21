#!/usr/bin/perl

use strict;
use warnings;

use autodie;

use Test::More tests => 13;

sub my_test
{
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    my ( $MOD, $MAX, $blurb ) = @_;

    my $prefix = qq#MOD="$MOD" MAX="$MAX" #;
    system("$prefix perl euler-250-v1-step1.pl > mod_counts.txt");
    system(
        "$prefix perl euler-250-v1-step2.bash < mod_counts.txt > mod_groups.txt"
    );

    my ($got) =
        `$prefix python euler_250_v1_step3.py` =~ /^Final result = ([0-9]+)$/ms
        or die "Not found.";
    my ($want) =
`$prefix /home/shlomif/Download/unpack/prog/python/pypy2-v5.3.0-src/pypy/goal/pypy-c euler_250_v1_step3_brute_force.py`
        =~ /^Num = ([0-9]+)/ms
        or die "brute not found.";

    return is( $got, $want, "$prefix $blurb" );
}

{
    # TEST
    my_test( 2, 2, "2;2" );

    # TEST
    my_test( 2, 3, "2;3" );

    # TEST
    my_test( 2, 4, "2;4" );

    # TEST
    my_test( 2, 5, "2;5" );

    # TEST
    my_test( 2, 6, "2;6" );

    # TEST
    my_test( 3, 3, "3;3" );

    # TEST
    my_test( 3, 4, "3;4" );

    # TEST
    my_test( 3, 5, "3;5" );

    # TEST
    my_test( 3, 6, "3;6" );

    # TEST
    my_test( 3, 7, "3;7" );

    # TEST
    my_test( 4, 4, "4;4" );

    # TEST
    my_test( 4, 5, "4;5" );

    # TEST
    my_test( 250, 10, "250;10" );
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
