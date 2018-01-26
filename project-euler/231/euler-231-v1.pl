#!/usr/bin/perl

use strict;
use warnings;
use autodie;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

open my $numer_fh, '<', 'factors-15M-to-20M.txt';
open my $denom_fh, '<', 'factors-2-to-5M.txt';

my (%f);

sub read_n
{
    my $factors = <$numer_fh>;
    chomp($factors);
    $factors =~ s#\A[0-9]+: *##;
    foreach my $f ( split( / /, $factors ) )
    {
        $f{$f}++;
    }
}

sub read_d
{
    my $factors = <$denom_fh>;
    chomp($factors);
    $factors =~ s#\A[0-9]+: *##;
    foreach my $f ( split( / /, $factors ) )
    {
        $f{$f}--;
    }
}

while ( !eof($numer_fh) and !eof($denom_fh) )
{
    read_n();
    read_d();
}

while ( !eof($numer_fh) )
{
    read_n();
}
while ( !eof($denom_fh) )
{
    read_d();
}
close($numer_fh);
close($denom_fh);

my $sum = 0;

while ( my ( $f, $c ) = each(%f) )
{
    if ( $c < 0 )
    {
        die "Factor $f is $c!";
    }
    $sum += $f * $c;
}

print "Sum = $sum\n";

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
