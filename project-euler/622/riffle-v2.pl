#!/usr/bin/perl

use strict;
use warnings;
use integer;
use bigint;

sub divisors
{
    local $_ = shift;
    s/\A([0-9]+):\s*//;
    my $n = $1;
    my %f;
    foreach my $f ( split /\s+/, $_ )
    {
        die if $f !~ /\S/;
        $f{$f}++;
    }

    my @t;
    while ( my ( $k, $v ) = each %f )
    {
        push @t, [ $k => $v ];
    }
    return f(@t);
}

sub f
{
    if ( !@_ )
    {
        return (1);
    }
    else
    {
        my ( $f, $m ) = @{ shift(@_) };
        my @r = f(@_);

        my $x = 1;
        my @ret;
        for my $e ( 0 .. $m )
        {
            push @ret, map { $x * $_ } @r;
        }
        continue
        {
            $x *= $f;
        }
        return @ret;
    }
}

sub t_div
{
    my $n = shift;

    return +{ map { $_ => 1 } divisors( scalar `factor "$n"` ) };
}

sub pow_div
{
    return t_div( ( 1 << shift ) - 1 );
}

my $n = 60;

my $divs = pow_div($n);
foreach my $h ( map { pow_div($_) } grep { $n % $_ == 0 } 1 .. $n - 1 )
{
    delete @{$divs}{ keys %$h };
}

my $sum = 0;
foreach my $k ( keys %$divs )
{
    $sum += $k + 1;
}
print "sum = $sum\n";

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
