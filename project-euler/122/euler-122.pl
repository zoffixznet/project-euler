#!/usr/bin/perl

use strict;
use warnings;

use integer;

use List::MoreUtils qw(uniq);
use List::Util qw(min);

my @combinations = ( undef, [ { 1 => 1 } ] );

sub is_superset
{
    my ( $super, $sub, $true_superset ) = @_;

    foreach my $key ( keys(%$sub) )
    {
        if ( !exists( $super->{$key} ) )
        {
            return;
        }
    }

    return ( ( !$true_superset ) || ( keys(%$super) > keys(%$sub) ) );
}

my $sum = 0;
foreach my $n ( 2 .. 200 )
{
    print "Reached $n\n";
    my $sets = [];

    foreach my $lower ( 1 .. ( $n >> 1 ) )
    {
        my $upper = $n - $lower;

    U_SET:
        foreach my $u_set ( @{ $combinations[$upper] } )
        {
            if ( !exists( $u_set->{$lower} ) )
            {
                next U_SET;
            }

            my %new_set_hash = %$u_set;
            $new_set_hash{$n} = 1;

        CALC_NEW_SETS:
            {
                my @new_sets;

            SUPERSETS:
                foreach my $exist_idx ( 0 .. $#$sets )
                {
                    my $s = $sets->[$exist_idx];
                    if ( is_superset( $s, ( \%new_set_hash ), 1 ) )
                    {
                        next SUPERSETS;
                    }

                    # If the new set is a superset of an existing set,
                    # then we don't want it here. Put all the existing sets in
                    # place and skip this loop.
                    elsif ( is_superset( ( \%new_set_hash ), $s, 0 ) )
                    {
                        last CALC_NEW_SETS;
                    }
                    else
                    {
                        push @new_sets, $s;
                    }
                }

                push @new_sets, ( \%new_set_hash );
                $sets = \@new_sets;
            }
        }
    }

    # $combinations[$n] = [sort { $a cmp $b } keys(%sets)];
    $combinations[$n] = $sets;

    my $result = -1 + min( map { scalar( keys(%$_) ) } @{ $combinations[$n] } );

    print "Found $result\n";

    $sum += $result;
}

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
