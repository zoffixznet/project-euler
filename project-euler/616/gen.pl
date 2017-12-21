#!/usr/bin/perl

use strict;
use warnings;

use Path::Tiny qw/ path /;

my @db = path("factor.db")->lines_raw;
foreach my $i ( @db[ 2 .. $#db ] )
{
    $i = [ map { int $_ } $i =~ s#[^:]*:##r =~ /([0-9]+)/g ];
}

for my $base ( 2 .. 1_000_000 )
{
    my $exp          = 2;
    my $n            = $base * $base;
    my $base_factors = $db[$base];
    while ( $n <= 1000000000000 )
    {
        my @tot = sort { $a <=> $b } @$base_factors, @{ $db[$exp] };
        if ( @tot >= 4 or ( @tot == 3 and $tot[-1] > 2 ) )
        {
            print "$n\n";
        }
    }
    continue
    {
        ++$exp;
        $n *= $base;
    }
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
