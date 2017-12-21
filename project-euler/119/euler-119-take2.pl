#!/usr/bin/perl

use strict;
use warnings;

use integer;

use List::Util qw(sum);

use Math::BigInt ":constant", "lib" => "GMP";
use Heap::Fibonacci;

package Exponents;

open my $primes_fh, '-|', 'primes', '3'
    or die "Cannot open primes";

my @prime_exponents = ( { e => 2, b => 2 } );

sub peek_exp
{
    my $i = shift;

    my $p_exp = (
        $prime_exponents[$i] ||=
            do
        {
            my $p = <$primes_fh>;
            chomp($p);
            { e => $p, b => 2, };
            }
    );

    return $p_exp->{b}**$p_exp->{e};
}

sub get_exp
{
    my $i = shift;

    my $p_exp = $prime_exponents[$i];

    my $ret = $p_exp->{b}**$p_exp->{e};

    $p_exp->{b}++;

    return $ret;
}

package MyHeapElem;

use parent 'Heap::Elem';

use List::Util qw(reduce);

use vars qw($a $b);

sub new
{
    my $class = shift;

    my $self = bless {}, $class;

    # set $self->{key} = $value;
    my ($e_idx) = @_;

    my $p_exp =

        $self->{e} = $e_idx;
    $self->{n} = Exponents::get_exp($e_idx);

    return $self;
}

sub cmp
{
    my $self  = shift;
    my $other = shift;

    return (   ( ( $self->{n} <=> $other->{n} ) )
            || ( ( $self->{e} <=> $other->{e} ) ) );
}

sub val
{
    my $self = shift;

    if (@_)
    {
        $self->{val} = shift;
    }

    return $self->{val};
}

sub heap
{
    my $self = shift;

    if (@_)
    {
        $self->{heap} = shift;
    }

    return $self->{heap};
}

package main;

my $heap = Heap::Fibonacci->new;

$heap->add( MyHeapElem->new(0) );

my $power_num_idx  = 0;
my $last_power_num = 0;

I_LOOP:
while (1)
{
    my $i_rec = $heap->extract_top();

    my $i = $i_rec->{n};

    my $e_idx = $i_rec->{e};

    my $next_exp_i = Exponents::peek_exp($e_idx);

    while ( Exponents::peek_exp($e_idx) <= $next_exp_i )
    {
        $heap->add( MyHeapElem->new( $e_idx++ ) );
    }

    if ( length($i) == 1 )
    {
        next I_LOOP;
    }
    my $s = sum( split //, $i );

    if ( $s == 1 )
    {
        next I_LOOP;
    }
    my $pow = $s * $s;

    while ( $pow < $i )
    {
        $pow *= $s;
    }

    if ( $pow == $i and $pow != $last_power_num )
    {
        $power_num_idx++;
        print "a[$power_num_idx] = $i\n";
        $last_power_num = $i;
    }
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
