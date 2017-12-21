package Euler250;

use strict;
use warnings;

use integer;
use bytes;

use Math::GMP;

use Moo;

# use Math::GMP ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

our $NUM_DIGITS = 251;
our $MAX_DIGIT  = $NUM_DIGITS - 1;
our @DIGITS     = ( 0 .. $MAX_DIGIT );

sub gen_empty_matrix
{
    return [
        map {
            [ map { 0 } @DIGITS ]
        } @DIGITS
    ];
}

sub assign
{
    my ( $m, $m_t, $to, $from, $val ) = @_;

    $m->[$to]->[$from] = $m_t->[$from]->[$to] = $val;

    return;
}

sub multiply
{
    my ( $m1, $m2_t ) = @_;

    my $ret   = gen_empty_matrix();
    my $ret_t = gen_empty_matrix();

    foreach my $row_idx (@DIGITS)
    {
        my $m1_row = $m1->[$row_idx];
        foreach my $col_idx (@DIGITS)
        {
            my $sum    = 0;
            my $m2_col = $m2_t->[$col_idx];
            foreach my $i (@DIGITS)
            {
                ( $sum += $m1_row->[$i] * $m2_col->[$i] ) %= 1_000_000_000;
            }
            assign( $ret, $ret_t, $row_idx, $col_idx, $sum );
        }
    }
    return { normal => $ret, transpose => $ret_t };
}

sub gen_zero_matrix
{
    my $m   = gen_empty_matrix;
    my $m_t = gen_empty_matrix;

    assign( $m, $m_t, $row_idx, $col_idx, $sum );
}

my $matrix1   = gen_empty_matrix();
my $matrix1_t = gen_empty_matrix();

for my $i ( 1 .. $MAX_DIGIT )
{
    assign( $matrix1, $matrix1_t, $i, $i - 1, 1 );
    assign( $matrix1, $matrix1_t, 0,  $i - 1, 1 );
}

my %init_count_cache =
    ( 1 => +{ normal => $matrix1, transpose => $matrix1_t } );

has 'count_cache' =>
    ( is => 'rw', default => sub { return +{%init_count_cache}; } );

sub calc_count_matrix
{
    my ( $self, $n ) = @_;

    return $self->count_cache->{"$n"} //= sub {

        # return $count_cache{"$n"} // sub {
        # Extract the lowest bit.
        my $recurse_n = $n - ( $n & ( $n - 1 ) );
        my $second_recurse_n = $n - $recurse_n;

        if ( $recurse_n == 0 )
        {
            ( $recurse_n, $second_recurse_n ) =
                ( $second_recurse_n, $recurse_n );
        }

        if ( $second_recurse_n == 0 )
        {
            $recurse_n = $second_recurse_n = ( $n >> 1 );
        }

        return multiply(
            $self->calc_count_matrix($recurse_n)->{normal},
            $self->calc_count_matrix($second_recurse_n)->{transpose}
        );
        }
        ->();
}

sub calc_count
{
    my ( $self, $n ) = @_;

    return ( $n == 0 ) ? 1 : $self->calc_count_matrix($n)->{normal}->[0]->[0];
}

sub print_rows
{
    my ($mat) = @_;

    foreach my $row (@$mat)
    {
        print "Row = ", sum(@$row), "\n";
    }
}

has 'BASE' => ( is => 'rw', default => sub { return 13; }, );
has 'N_s' => (
    is      => 'rw',
    default => sub {
        my ($self) = @_;
        my @N_s = ( $self->BASE() );

        for my $i ( 2 .. 17 )
        {
            push @N_s, $N_s[-1] * $self->BASE();
        }
        return \@N_s;
    }
);

has 'mult_cache' => ( is => 'rw', default => sub { return +{}; } );

sub calc_multiplier
{
    my ( $self, $sum ) = @_;

    return (
        $self->mult_cache->{$sum} //= sub {
            my $ret = 0;

            for my $n ( @{ $self->N_s() } )
            {
                # print "calc_multiplier for $n\n";
                if ( $n >= $sum )
                {
                    $ret += $self->calc_count( $n - $sum );
                    $ret %= 1_000_000_000;
                }
            }

            return $ret;
        }
            ->()
    );
}

my @FACTs = (1);

for my $i ( 1 .. 9 )
{
    push @FACTs, $i * $FACTs[-1];
}

sub recurse_digits
{
    my ( $self, $count, $digits, $sum ) = @_;

    if ( $count == $MAX_DIGIT )
    {
        # print "Trace: ", (map { ($_->[0]) x $_->[1] } @$digits), "\n";
        my $multiplier = $self->calc_multiplier($sum);

        my $digit_base = 0;

        # my $count_variations = $FACTs[9]->gmp_copy;
        my $count_variations = $FACTs[9] + 0;

        for my $digit (@$digits)
        {
            $count_variations /= $FACTs[ $digit->[1] ];
        }
        for my $digit (@$digits)
        {
            $digit_base += $count_variations * $digit->[1] * $digit->[0];
        }
        $digit_base /= $count;

        my $ret = (
            (
                ( Math::GMP->new($digit_base) * Math::GMP->new(111_111_111) ) *
                    Math::GMP->new($multiplier)
            ) % 1_000_000_000
        );

        # print "Trace: ", (map { ($_->[0]) x $_->[1] } @$digits), " += $ret\n";

        return $ret . '';
    }
    else
    {
        my ( $last_digit, $last_digit_count ) = @{ $digits->[-1] };

        my $ret = 0;

        $ret += $self->recurse_digits(
            $count + 1,
            [
                @$digits[ 0 .. $#$digits - 1 ],
                [ $last_digit, $last_digit_count + 1 ],
            ],
            $sum + $last_digit
        );

        $ret %= 1_000_000_000;

        foreach my $new_digit ( $last_digit + 1 .. 9 )
        {
            $ret += $self->recurse_digits(
                $count + 1,
                [ @$digits, [ $new_digit, 1 ] ],
                $sum + $new_digit,
            );
            $ret %= 1_000_000_000;
        }

        return $ret;
    }
}

sub calc_result_above
{
    my ($self) = @_;

    my $result = 0;
    foreach my $new_digit ( 1 .. 9 )
    {
        $result +=
            $self->recurse_digits( 1, [ [ $new_digit, 1 ] ], $new_digit, );
        $result %= 1_000_000_000;
    }

    return $result;
}

sub calc_result_below
{
    my ($self) = @_;

    if ( $self->BASE() > 9 * 9 )
    {
        return 0;
    }

    return $self->recurse_below( '', 0 );
}

sub calc_result
{
    my ($self) = @_;

    my $ret = $self->calc_result_above() + $self->calc_result_below();

    $ret %= 1_000_000_000;

    return $ret;
}

# Calculate the sum of the numbers below 1e9 whose sum-of-digits equal 13.
# as it is absent from the total sum.

sub recurse_below
{
    my ( $self, $n, $sum ) = @_;

    if ( length($n) == 9 )
    {
        return 0;
    }
    if ( $sum == $self->BASE() )
    {
        # print "Trace[have]: ", (sort { $a <=> $b } split//,$n), " += $n\n";
        return $n;
    }

    my $ret = 0;
NEW:
    foreach my $new_digit ( 1 .. $MAX_DIGIT )
    {
        if ( $sum + $new_digit > $self->BASE() )
        {
            last NEW;
        }
        $ret += $self->recurse_below( $new_digit . $n, $sum + $new_digit );
    }
    return $ret;
}

sub _mod
{
    my ($n) = @_;

    my $ret = substr( $n, -9 );

    $ret =~ s/\A0+//;

    return $ret;
}

sub recurse_brute_force
{
    my ( $TARGET, $n, $sum ) = @_;

    if ( $sum == $TARGET )
    {
        my $ret = _mod($n);

       # print "Trace[want]: ", (sort { $a <=> $b } split//,$ret), " += $ret\n";
        return $ret;
    }

    my $ret = 0;
NEW:
    foreach my $new_digit ( 1 .. $MAX_DIGIT )
    {
        if ( $sum + $new_digit > $TARGET )
        {
            last NEW;
        }
        $ret +=
            recurse_brute_force( $TARGET, $new_digit . $n, $sum + $new_digit );
        $ret = _mod($ret);
    }
    return $ret;
}

sub calc_using_brute_force
{
    my ( $self, $TARGET ) = @_;

    return recurse_brute_force( $TARGET, '', 0 );
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
