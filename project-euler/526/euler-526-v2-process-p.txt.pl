#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $log_fn = 'found-log.txt';

sub get_last
{
    my $s = `cat "$log_fn" | tail -3`;

    my @n = $s =~ /Max = \K([0-9]+)/g;

    return $n[-1];
}

my $max = ( ( -e $log_fn ) ? get_last() : 0 );

open my $log_fh, '>>', $log_fn;
$log_fh->autoflush(1);
while ( my $l = <ARGV> )
{
    my ($n) = ( $l =~ /([0-9]+)/g );
    my $sum =
`seq "$n" "@{[$n+8]}" | factor | perl -lane '\$s += \$F[-1]; END { print \$s }'`;
    chomp($sum);
    if ( $sum > $max )
    {
        $max = $sum;
        my $str = "Found n = $n Max = $max\n";
        print $str;
        $log_fh->print($str);
    }
}

close($log_fh);

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
