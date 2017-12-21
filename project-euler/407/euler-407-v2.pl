#!/usr/bin/perl

use strict;
use warnings;

use v5.16;

use integer;
use bytes;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $bitmask = '';

my $lim_line = <>;

my ($LIM) = $lim_line =~ /([0-9]+)/g;
my $STEP = 10_000;

my $count = 0;
my $sum   = 0;
my $pr    = $LIM - $STEP;
MAIN:
while ( my $l = <> )
{
    my ( $A, $Asq, @p ) = ( $l =~ /([0-9]+)/g );
    if ( !@p )
    {
        last MAIN;
    }
    my %q;
    for my $p (@p)
    {
        $q{$p}++;
    }
    my $rec = sub {
        my ( $n, $d ) = @_;

        if ( !@$d )
        {
            if ( $n > $A )
            {
                if ( !vec( $bitmask, $n, 1 ) )
                {
                    # print "f($n) = $A\n";
                    vec( $bitmask, $n, 1 ) = 1;
                    $sum += $A;

                    # print "Sum[Intermediate] = $sum\n";
                    $count++;
                }
            }
            return;
        }
        my $p = shift(@$d);
        my $e = shift(@$d);
        for my $m ( 0 .. $e )
        {
            __SUB__->( $n, [@$d] );
        }
        continue
        {
            if ( ( $n *= $p ) > $LIM )
            {
                return;
            }
        }
        return;
    };
    $rec->( 1, [%q] );
    if ( $A == $pr )
    {
        print "A=$A sum=$sum\n";
        $pr -= $STEP;
    }
}

$sum += $LIM - 1 - $count;
print "Sum = $sum\n";

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
