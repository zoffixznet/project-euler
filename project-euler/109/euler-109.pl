#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(sum);

my %registry;
my @score_lists;

sub handle_final_doubles
{
    my ($results) = @_;

    foreach my $double_result ( 1 .. 20, 25 )
    {
        my $id =
            join( ',', sort { $a cmp $b } map { join( '*', @$_ ) } @$results )
            . ";$double_result*2";

        if ( !exists( $registry{$id} ) )
        {
            my $score = sum( map { $_->[0] * $_->[1] } @$results,
                [ $double_result, 2 ] );
            $registry{$id} = $score;
            push @{ $score_lists[$score] }, $id;
        }
    }
}

sub recurse
{
    my ($results) = @_;

    my $depth = @$results;

    handle_final_doubles($results);

    if ( $depth < 2 )
    {
        foreach my $multiplier ( 1 .. 3 )
        {
            foreach my $new_res ( 1 .. 20 )
            {
                recurse( [ @$results, [ $new_res, $multiplier ] ] );
            }
        }

        foreach my $multiplier ( 1 .. 2 )
        {
            recurse( [ @$results, [ 25, $multiplier ] ] );
        }
    }

    return;
}

recurse( [] );

if ( @{ $score_lists[6] } != 11 )
{
    die "Number of checkouts for 6 is not correct.";
}

print "Total = ",
    ( sum( map { scalar( @{ $_ || [] } ) } @score_lists[ 1 .. 99 ] ) ), "\n";

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
