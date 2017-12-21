#!/usr/bin/perl

use strict;
use warnings;
use autodie;
use bigint;

my $MAX = 1000000000000;

open my $fh, "primesieve -p 1000160 1000000000000|";

my $c   = 0;
my $s   = 0;
my $d   = 1000000;
my $inv = $MAX / $d;

my $MIN_d = 28;
STDOUT->autoflush(1);
while ( my $p = <$fh> )
{
    chomp $p;
    while ( $p > $inv )
    {
        print "d = $d count = $c sum = $s\n";
        if ( --$d == $MIN_d )
        {
            close $fh;
            exit;
        }
        $inv = $MAX / $d;
    }
    ++$c;
    $s += $p;
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
