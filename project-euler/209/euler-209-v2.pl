#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Data::Dumper;

use List::Util qw(sum);
use List::MoreUtils qw(any none);

STDOUT->autoflush(1);

my @Graph;
foreach my $inputs ( 0 .. ( 2**6 - 1 ) )
{
    my ( $aa, $bb, $cc, $dd, $ee, $ff ) = split //, sprintf "%06b", $inputs;
    my $new =
        eval( "0b$bb$cc$dd$ee$ff" . ( ( $aa xor( $bb && $cc ) ) ? '1' : '0' ) );
    push @{ $Graph[$inputs] }, $new;
    push @{ $Graph[$new] },    $inputs;
}

foreach my $node (@Graph)
{
    $node = [ sort { $a <=> $b } @$node ];
}

# Find Fully-connected components (FCCs).

my @FCCs = ( [] );

my %to_traverse = ( map { $_ => 1 } keys @Graph );

foreach my $inputs ( 0 .. ( 2**6 - 1 ) )
{
    my @q = ($inputs);
    while ( defined( my $i = shift(@q) ) )
    {
        if ( exists( $to_traverse{$i} ) )
        {
            delete $to_traverse{$i};
            push @{ $FCCs[-1] }, $i;
            push @q, @{ $Graph[$i] };
        }
    }

    if ( @{ $FCCs[-1] } )
    {
        $FCCs[-1] = [ sort { $a <=> $b } @{ $FCCs[-1] } ];
        push @FCCs, [];
    }
}

if ( !@{ $FCCs[-1] } )
{
    pop(@FCCs);
}

my $result = 1;

my @dead_ends;
my @queue;

my $initial_state = '';
for my $i ( 0 .. 64 - 1 )
{
    vec( $initial_state, $i, 2 ) = 3;
}
vec( $initial_state, 0, 2 ) = 0;

foreach my $fcc (@FCCs)
{
    @queue     = ();
    @dead_ends = ();

    foreach my $i ( grep { $_ != 0 } @$fcc )
    {
        if ( @{ $Graph[$i] } == 1 )
        {
            push @dead_ends, $Graph[$i][0];
        }
        else
        {
            push @queue, $i;
        }
    }
    $result *= recurse( 0, $initial_state );
}

print "Result == $result\n";

# print Dumper ([ \@FCCs ] )

sub recurse
{
    # $d is depth.
    # $s is state.
    my ( $d, $s ) = @_;

    if ( $d == @queue )
    {
        # print "Foo\n";
        return ( 1 << ( scalar grep { vec( $s, $_, 2 ) == 0 } @dead_ends ) );
    }

    my $inputs = $queue[$d];
    my $new_d  = $d + 1;

    if ( vec( $s, $inputs, 2 ) == 0 )
    {
        return recurse( $new_d, $s );
    }

    vec( $s, $inputs, 2 ) = 0;

    my $ret = recurse( $new_d, $s );

    vec( $s, $inputs, 2 ) = 1;

    for my $l ( @{ $Graph[$inputs] } )
    {
        vec( $s, $l, 2 ) = 0;
    }
    $ret += recurse( $new_d, $s );

    return $ret;
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
