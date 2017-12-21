package Euler320;

use strict;
use warnings;

use integer;
use bytes;

use parent 'Exporter';

our @EXPORT_OK = qw(factorial_factor_exp find_exp_factorial sum_factorials);

use Math::BigInt lib => 'GMP';

use Tree::AVL;
use IO::All qw/io/;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

sub factorial_factor_exp
{
    my ( $n, $f ) = @_;

    if ( $n < $f )
    {
        return 0;
    }
    else
    {
        my $div = $n / $f;
        return $div + factorial_factor_exp( $div, $f );
    }
}

# Finds the minimal n-factorial whose exponent is larger than $e
sub find_exp_factorial
{
    my ( $f, $e, $bb, $tt ) = @_;

    my $find;

    $find = sub {
        my ( $bottom, $top ) = @_;

        if ( $bottom > $top )
        {
            return $top;
        }
        my $top_val = factorial_factor_exp( $top, $f );

        if ( $top_val < $e )
        {
            return $find->( $top, $top << 1 );
        }
        my $bottom_val = factorial_factor_exp( $bottom, $f );
        if ( $bottom_val < $e and ( $top == $bottom + 1 ) )
        {
            return $top;
        }

        my $mid = ( ( $bottom + $top ) >> 1 );
        my $mid_val = factorial_factor_exp( $mid, $f );

        if ( $mid_val < $e )
        {
            return $find->( $mid, $top );
        }
        return $find->( $bottom, $mid );
    };

    return $find->( $bb, $tt );
}

{
    my %factors_exp = ();

    my $tree = Tree::AVL->new(
        fcompare => sub {
            my ( $A, $B ) = @_;
            return ( $A->{v} <=> $B->{v} or $A->{f} <=> $B->{f} );
        },
        fget_key => sub {
            return shift->{v};
        },
        fget_data => sub {
            return $factors_exp{ shift->{f} }->{'e'};
        },
    );

    # This is the S function
    sub sum_factorials
    {
        my ($n) = @_;

        my $fh = io->file("./factors-2-to-1000000.txt");

        my $mult = Math::BigInt->new('1234567890');

        my $read_line = sub {
            my %factors = split /,/, $fh->chomp->getline;

            while ( my ( $f, $e ) = each %factors )
            {
                if ( !exists( $factors_exp{$f} ) )
                {
                    $tree->insert(
                        $factors_exp{$f} = +{
                            f => $f,
                            e => Math::BigInt->new(0),
                            v => Math::BigInt->new(1),
                        },
                    );
                }
                my $rec = $factors_exp{$f};

                $tree->delete($rec);

                $rec->{e} += $mult * $e;
                $rec->{v} = find_exp_factorial( $f, $rec->{e}, $rec->{v},
                    $rec->{v} << 1 );

                $tree->insert($rec);
            }
        };

        for my $i ( 2 .. 9 )
        {
            $read_line->();
        }

        my $S    = Math::BigInt->new('0');
        my $BASE = Math::BigInt->new('10')**18;
        for my $i ( 10 .. $n )
        {
            $read_line->();
            my $L = $tree->largest();
            $S += $L->{'v'};
            print "$i : F = $L->{f} ; S = $S ; Smod = ", ( $S % $BASE ), "\n";
        }

        return $S;
    }

}

1;

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
