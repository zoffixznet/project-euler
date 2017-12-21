#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::GMP;

use Math::BigInt lib => 'GMP';    #, ':constant';

use List::Util qw(reduce sum);
use List::MoreUtils qw(all);

use Math::ModInt qw(mod);
use Math::ModInt::ChineseRemainder qw(cr_combine cr_extract);

my $MAX    = 300000;
my @primes = `primes 2 $MAX`;
chomp(@primes);

# @r = records.
my @r = ( map { +{ n => $_ } } @primes );
STDOUT->autoflush(1);

my $sum = 0;
my $accum_mod;
for my $idx ( keys @r )
{
    my $rec = $r[$idx];
    my $n   = $rec->{n};

    print "Reached i=$idx n=$n\n";
    my $big_n = Math::BigInt->new($n);
    my $this_mod = mod( $idx + 1, $big_n );
    $accum_mod = $idx ? cr_combine( $accum_mod, $this_mod ) : $this_mod;
    $rec->{A} = $accum_mod->residue;

    my $verdict = sub {
        for my $p ( 0 .. $idx - 1 )
        {
            if ( $r[$p]->{A} % $big_n == 0 )
            {
                return 1;
            }
        }
        return 0;
        }
        ->();

    if ($verdict)
    {
        $sum += $n;
        print "Found n=$n sum=$sum\n";
    }
}

print "Final sum = $sum\n";

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
