#!/usr/bin/perl

use strict;
use warnings;

use POSIX qw(floor);

my $mod_u_0 = -1_000_000_000;

sub mod_f
{
    return floor( 2**( 30.403243784 - ( shift() * 1e-9 )**2 ) );
}

my %found;

my $u = $mod_u_0;
my $n = 0;
$found{$u} = $n;
while (1)
{
    my $new_u = mod_f($u);
    if ( ( ++$n ) % 100_000 == 0 )
    {
        print "Reached $n\n";
    }
    print "found[$n] = $new_u\n";
    if ( exists( $found{$new_u} ) )
    {
        print "found[$found{$new_u}] = found[$n]\n";
        exit(0);
    }
    $found{$new_u} = $n;
    $u = $new_u;
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
