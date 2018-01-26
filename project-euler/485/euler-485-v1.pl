#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Tree::AVL;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my ( $MAX, $STEP, $DISPLAY_STEP, $THRESHOLD ) = @ARGV;

my $DS = $DISPLAY_STEP;
my $TH = $THRESHOLD;

# A tree
my $T = Tree::AVL->new(
    fcompare => sub {
        my ( $A, $B ) = @_;
        return ( $A->[1] <=> $B->[1] or $A->[0] <=> $B->[0] );
    },
    fget_key => sub {
        return shift->[1];
    },
    fget_data => sub {
        return shift->[0];
    },
);

# A queue.
my @Q;

open my $fh, sprintf( "seq 1 '%d' | xargs factor |", $MAX + 1 );

my $sum = 0;

sub add
{
    my $l = <$fh>;
    chomp($l);
    my %f;
    my @f   = $l =~ /([0-9]+)/g;
    my $n   = shift(@f);
    my $val = 1;
    for my $i (@f)
    {
        $f{$i}++;
    }
    for my $x ( values %f )
    {
        $val *= ( 1 + $x );
    }

    if ( $val >= $TH )
    {
        my $rec = [ $n, $val ];
        push @Q, $rec;
        $T->insert($rec);
    }

    return;
}

for my $i ( 1 .. $STEP )
{
    add();
}

sub update
{
    $sum += $T->largest()->[1];
    return;
}

update();
for my $n ( $STEP + 1 .. $MAX )
{
    my $l = $n - $STEP;
    while ( @Q and $Q[0][0] <= $l )
    {
        $T->delete( shift @Q );
    }
    add();
    update();
    if ( $n % $DS == 0 )
    {
        print "Reached $n : Sum = $sum\n";
    }
}
print "Final Sum = $sum\n";

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
