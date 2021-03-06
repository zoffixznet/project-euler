#! /usr/bin/env perl
#
# Short description for 359-v1-test.pl
#
# Author shlomif <shlomif@cpan.org>
# Version 0.1
# Copyright (C) 2018 shlomif <shlomif@cpan.org>
# Modified On 2018-04-13 15:57
# Created  2018-04-13 15:57
#
use strict;
use warnings;
use 5.022;
use bigint;

sub is_sq
{
    my ($n) = @_;
    my $r = sqrt $n;
    return $r * $r == $n;
}

my $h = [];
my $n = 1;
N:
while (1)
{
    foreach my $pp (@$h)
    {
        if ( is_sq( $pp->[-1] + $n ) )
        {
            push @$pp, $n;
            next N;
        }
    }
    push @$h, [$n];
}
continue
{
    while ( my ( $i, $fl ) = each @$h )
    {
        print $i + 1, ': ', ( join ' ', @$fl ), "\n";
    }
    print '-' x 80, "\n";
    ++$n;
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
