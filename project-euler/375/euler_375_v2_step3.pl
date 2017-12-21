#!/usr/bin/perl

use strict;
use warnings;

use bigint;

sub lookup
{
    my ($place) = @_;

    return 0 + ( `grep -F 'M($place) =' < dump_v3` =~ s/.* = //r );
}

my $delta = 6308949 - 1;
my $s     = $delta + 1;
my $s2    = $s + $delta;
my $m_s   = lookup($s);
my $m_s2  = lookup($s2);

my $m_delta = $m_s2 - $m_s;

my $n = $s2;
my $m = $m_s2 + 0;

# my $TARGET = $delta * 4 + 24024;
my $TARGET = 2_000_000_000;

my $s_t = ( ( $TARGET - 1 ) % $delta + 1 );
my $s_t_min_1 = $s_t - 1;

my $m_s2_t = $s2 + $s_t_min_1;

my $MIN_ELEM = 3;
print "\$s = $s\n";
print "\$s2 = $s2\n";
print "\$m_s2_t = $m_s2_t\n";
print "\$s_t_min_1 = $s_t_min_1\n";
my $delta_t2 = lookup($m_s2_t) - $m_s2;
$n += $delta;
while ( $n <= $TARGET )
{
    $m_delta  += $MIN_ELEM * $delta * $delta;
    $delta_t2 += $MIN_ELEM * $delta * $s_t_min_1;
    $m        += $m_delta;
}
continue
{
    $n += $delta;
}
print "M(@{[$n-$delta]}) = $m\n";
print "M(@{[$TARGET]}) = @{[$m + $delta_t2]}\n";

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
