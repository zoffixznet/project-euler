#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $n = shift(@ARGV);

my $start = $n + 8;

open my $fh, qq#seq "$start" -1 2 | factor|#
    or die "Cannot open pipeline - $!";

sub myr
{
    my $l = <$fh>;
    chomp($l);
    my ($i) = $l =~ /([0-9]+)$/;
    return $i;
}

my @f_s;
my $sum = 0;

sub update
{
    my $x = myr();
    $sum += $x;
    push @f_s, $x;
}

for my $i ( 0 .. 8 )
{
    update();
}

my $max = 0;
my $i   = $n;

while ( $i >= 3 )
{
    if ( $sum > $max )
    {
        $max = $sum;
        print "Found New Max g($i) = $max\n";
    }
    $sum -= shift(@f_s);
    update();
}
continue
{
    $i--;
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
