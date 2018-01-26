#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 19;

use Test::Differences (qw( eq_or_diff ));

my $which = $ENV{'WHICH_CMD'};

my $CMD = (
      $which eq '1' ? 'perl euler-305-v1.pl'
    : $which eq '2' ? './e305-debug.exe'
    : $which eq '3' ? './e305-prod.exe'
    :                 ( die "Unknown WHICH_CMD" )
);

sub mytest
{
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my ( $needle, $count, $blurb ) = @_;

    return eq_or_diff(
        scalar(`$CMD $needle $count`),
        scalar(`bash good-results.bash $needle $count`),
        "$blurb - $needle $count",
    );
}

{
    # TEST
    mytest( 1, 100, "Euler 305" );

    # TEST
    mytest( 2, 100, "Euler 305" );

    # TEST
    mytest( 3, 100, "Euler 305" );

    # TEST
    mytest( 10, 100, "Euler 305" );

    # TEST
    mytest( 11, 100, "Euler 305" );

    # TEST
    mytest( 9, 100, "Euler 305" );

    # TEST
    mytest( 100, 100, "Euler 305" );

    # TEST
    mytest( 101, 20, "Euler 305" );

    # TEST
    mytest( 102, 20, "Euler 305" );

    # TEST
    mytest( 91, 100, "Euler 305" );

    # TEST
    mytest( 90, 100, "Euler 305 - do not halt on 90" );

    # TEST
    mytest( 99, 100, "Euler 305" );

    # TEST
    mytest( 891, 100, "Euler 305" );

    # TEST
    mytest( 910, 100, "Euler 305" );

    # TEST
    mytest( 911, 100, "Euler 305" );

    # TEST
    mytest( 1011, 100, "Euler 305" );

    # TEST
    mytest( 303, 100, "Euler 305" );

    # TEST
    mytest( 1912, 100, "Euler 305" );

    # TEST
    mytest( 243, 100, "Euler 305" );
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
