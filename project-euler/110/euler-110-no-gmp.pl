#!/usr/bin/perl

use strict;
use warnings;
use autodie;

=head1 ANALYSIS

ny + nx = xy

n (x+y) = xy

n = xy / (x+y)

x,y > n

1/y = 1/n-1/x = (x-n)/nx

y = nx/(x-n)

If t = x-n ; x = t + n

y = n*(t+n) / t = n + [ n^2 / t ]

t \in [1 .. n]

If n = p1^e1 * p2^e2 * p3^e3 ....

Then the number of t's is (2*e1+1)*(2*e2+1)*(2*e3+1)*(2*e4+1)/2

=cut

=begin Removed

use integer;

for (my $n = 1_000; ;$n++)
{
    my $count = 0;
    my $n_sq = $n * $n;

    for my $t (1 .. $n)
    {
        if (! ($n_sq % $t))
        {
            $count++;
        }
    }
    print "Reached $n [$count]\n";
    if ($count > 1_000)
    {
        print "N = $n\n";
        exit(0);
    }
}

=end Removed

=cut

use List::Util qw(reduce first);
use List::MoreUtils qw(any);

sub calc_rank
{
    my $factors = shift;
    return reduce { $a * $b } 1, map { $_ * 2 + 1 } @$factors;
}

my $limit        = 4_000_000;
my $num_divisors = ( $limit * 2 - 1 );

my $primes_list = '';
my $num_primes  = 0;

{
    open my $fh, '-|', 'primes', '2', '43';
    while ( my $p = <$fh> )
    {
        chomp($p);
        vec( $primes_list, $num_primes++, 32 ) = $p;
    }
    close($fh);
}

my @best = ( { n => 1, factors => [], rank => calc_rank( [] ), } );

my $continue = 1;

sub get_best_n
{
    return (
        first { $_->{rank} > $num_divisors }
        sort { $a->{n} <=> $b->{n} } @best
    );
}

my $last_best_n;

sub best_n_improved
{
    my $best_n = get_best_n();
    if ( !defined($best_n) )
    {
        return 1;
    }

    $best_n = $best_n->{n};
    if ( !defined($last_best_n) )
    {
        $last_best_n = $best_n;
        return 1;
    }
    elsif ( $last_best_n > $best_n )
    {
        $last_best_n = $best_n;
        return 1;
    }
    else
    {
        return;
    }
}

while ( best_n_improved() )
{
    print "Reached ", scalar(@best), "\n";
    my @new_best;

    foreach my $n_rec (@best)
    {
        my $n       = $n_rec->{n};
        my $factors = $n_rec->{factors};
        my $rank    = $n_rec->{rank};

        {
            foreach my $idx (
                0 .. (
                      ( @$factors == $num_primes )
                    ? ($#$factors)
                    : ( $#$factors + 1 )
                )
                )
            {
                my @new = @$factors;
                $new[$idx]++;
                my $new_n =
                    reduce { $a * $b } 1,
                    map { vec( $primes_list, $_, 32 )**$new[$_] }
                    ( 0 .. $#new );
                my $new_rank = calc_rank( \@new );
                if (
                    !any { $_->{n} <= $new_n && $_->{rank} >= $new_rank }
                    @new_best
                    )
                {
                    push @new_best,
                        { n => $new_n, factors => \@new, rank => $new_rank };
                }
            }
        }
    }

    # print "<<<<\n", (map { "[$_->{n}, $_->{rank}]\n" } @new_best), ">>>>\n";

    @best = @new_best;
}

print $last_best_n, "\n";

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
