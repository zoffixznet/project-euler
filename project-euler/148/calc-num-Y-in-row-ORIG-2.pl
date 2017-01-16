#!/usr/bin/perl

use strict;
use warnings;

use 5.016;

use List::Util qw(sum);
use integer;

# use Math::BigInt lib => 'GMP', ':constant';

my $B = 7;

sub calc_num_Y_in_row_n
{
    my $n_proto = shift;
    my $n       = $n_proto - 1;

    my @D;

    # my $digit_n = $n->copy();
    my $digit_n   = $n;
    my $power     = 1;
    my $total_mod = 0;
    while ($digit_n)
    {
        my $digit = ( $digit_n % $B );
        $total_mod = $total_mod + $digit * $power;
        push @D, { d => $digit, power => $power, total_mod => $total_mod };
        $digit_n /= $B;
        $power *= $B;
    }

    my $recurse = sub {
        my ($d_len) = @_;

        if ( $d_len <= 0 )
        {
            return 0;
        }
        else
        {
            my $big_Y_num =
                ( $D[$d_len]{power} - 1 - $D[ $d_len - 1 ]{total_mod} );
            my $big_Y_total = $big_Y_num * $D[$d_len]{d};

            return $big_Y_total +
                ( $D[$d_len]{d} + 1 ) * __SUB__->( $d_len - 1 );
        }
    };

    return $recurse->($#D);
}

my $DEBUG = 0;

sub calc_num_Y_in_7_consecutive_rows
{
    my $n_proto = shift;
    my $n       = $n_proto - 1;

    my @D;

    # my $digit_n = $n->copy();
    my $digit_n   = $n;
    my $power     = 1;
    my $total_mod = 0;
    while ($digit_n)
    {
        my $digit = ( $digit_n % $B );
        $total_mod = $total_mod + $digit * $power;
        push @D, { d => $digit, power => $power, total_mod => $total_mod };
        $digit_n /= $B;
        $power *= $B;
    }

    if ( $D[0]{d} != 0 )
    {
        die "Cannot proceeed with '$n'.";
    }

    if ($DEBUG)
    {
        foreach my $l ( keys(@D) )
        {
            print
"D[$l] = { p => $D[$l]{power} , d => $D[$l]{d} , total_mod => $D[$l]{total_mod} }\n";
        }
    }

    my $recurse = sub {
        my ($d_len) = @_;

        if ( $d_len <= 0 )
        {
            return 0;
        }
        else
        {
            my $big_Y_num =
                $B *
                ( $D[$d_len]{power} - 1 -
                    $D[ $d_len - 1 ]{total_mod} -
                    ( $B - 1 ) ) +
                ( ( $B * ( $B - 1 ) ) >> 1 );

            my $big_Y_total = $big_Y_num * $D[$d_len]{d};

            return $big_Y_total +
                ( $D[$d_len]{d} + 1 ) * __SUB__->( $d_len - 1 );
        }
    };

    return $recurse->($#D);
}

sub calc_num_Y_in_7x7_consecutive_rows
{
    my $n_proto = shift;
    my $n       = $n_proto - 1;

    my @D;

    # my $digit_n = $n->copy();
    my $digit_n   = $n;
    my $power     = 1;
    my $total_mod = 0;
    while ($digit_n)
    {
        my $digit = ( $digit_n % $B );
        $total_mod = $total_mod + $digit * $power;
        push @D, { d => $digit, power => $power, total_mod => $total_mod };
        $digit_n /= $B;
        $power *= $B;
    }

    if ( $D[1]{total_mod} != 0 )
    {
        die "Cannot proceeed with '$n'.";
    }

    my $recurse = sub {
        my ($d_len) = @_;

=head1 New Analysis

For d_len == 1 :

big_Y_num[n+0*B] = B * ( B**d_len - B) + B*(B-1)/2 = B*(B-1)/2
big_Y_total[0] = 0
big_Y_num[n+1*B] = B * ( Power[d_len] - B) + B*(B-1)/2 = B*(B-1)/2
big_Y_total[1] = 1 * big_Y_num[n+1*B]
big_Y_num[n+2*B] = B * ( Power[d_len] - B) + B*(B-1)/2
big_Y_total[1] = 2 * big_Y_num[n+2*B]
big_Y_total[x] = 2 * big_Y_num[n+x*B]

big_Y_total[n+x*B] = x * B * (B-1)/2

Ret[x for d_len == 1] = big_Y_total[x for d_len == 1]
Sigma[Big_Y_Total] = B*(B-1)/2* [ B * ( Power[d_len] - B) + B*(B-1)/2 ]

For d_len == 2

big_Y_num[n+0*B] = B * ( B**d_len - B ) + B*(B-1)/2
big_Y_total[0] = 0
big_Y_num[n+1*B] = B * ( B**d_len - B - 1*B) + B*(B-1)/2
big_Y_total[1] = Digit[d_len]*big_Y_num[n+1*B]

big_Y_num[n+x*B] = B * ( B**2 - B - x*B ) + (B*(B-1))/2 = B [ B - x - 1 + (B - 1) / 2] = B [ 3(B-1)/2 - x ]
big_Y_total[n+x*B] = Digit[d_len] * big_Y_num[n+x*B]
Ret[n+x*B] = big_Y_total[n+x*B] + (Digit[d_len]+1) * big_Y_total[x for d_len == 1] =
Digit[d_len] * big_Y_num[n+x*B] + (Digit[d_len]+1) * x * B * (B-1)/2 =
Digit[d_len] * B * [ 3(B-1)/2 - x] + (Digit[d_len]+1) * x * B * (B-1)/2 =

For d_len >= 2

big_Y_num[n+x*B] = B * ( Power[d_len] - B - total_mod[d_len-1] - x*B ) + (B*(B-1))/2 =
big_Y_total

=head1 Old Analysis

S(d) = B * (p - total_mod - B - B*d) + B*(B-1)/2

We seek (Sum[S[d=0] .. S[d=B-1]] of S(d)).

Sum = S(0) + S(1) + S(2) ... + S(B-1) =

B*B*(p-total_mod-B) - B*B*(Sum[0..B-1]) + B*B*(B-1)/2 =

B*B*[  (p - total_mod - B) - B*(B-1)/2 + (B-1)/2] =
B*B*[  (p - total_mod - B) - (B-1)/2*(B-1)] =
B*B*[  (p - total_mod - B) - (B-1)**2/2] =

=cut

        if ( $d_len <= 0 )
        {
            return 0;
        }
        else
        {
            my $big_Y_num =
                ( ( $B**2 ) *
                    ( $D[$d_len]{power} - $D[ $d_len - 1 ]{total_mod} - $B ) -
                    ( $B * ( $B - 1 ) )**2 /
                    2 );

            my $big_Y_total = $big_Y_num * $D[$d_len]{d};

            return $big_Y_total +
                ( $D[$d_len]{d} + 1 ) * __SUB__->( $d_len - 1 );
        }
    };

    my $ret = $recurse->($#D);

    if (1)
    {
        $DEBUG = 1;
        my $exp =
            sum( map { calc_num_Y_in_7_consecutive_rows( $n_proto + $_ * $B ) }
                0 .. $B - 1 );
        $DEBUG = 0;

        if ( $exp != $ret )
        {
            die "Calculation failure.";
        }
    }

    return $ret;
}

if ( $ENV{RUN} )
{
    my $START = 1_000_000_001;
    my $LIMIT = 1_008_840_175;
    my $limit = $LIMIT / $B;
    my $sum   = 0;

    my $n;

    my $i = $START;
    while ( ( $i % $B ) != 1 )
    {
        $sum += calc_num_Y_in_row_n($i);
        $i++;
    }
    my $e = $LIMIT;
    while ( ( $e % $B ) != 1 )
    {
        $sum += calc_num_Y_in_row_n($e);
        $e--;
    }

    # We don't calculate that in the 7 step loop.
    $sum += calc_num_Y_in_row_n($e);

    my $next_i = $i + 10_000;
    while ( $i < $e )
    {
        $sum += calc_num_Y_in_7_consecutive_rows($i);
        if ( $i >= $next_i )
        {
            print "Reached $i [Sum == $sum]\n";
            $next_i += 10_000;
        }
        $i += 7;
    }
    print "Final Sum == $sum\n";
}
elsif ( $ENV{TEST} )
{
    if (1)
    {
        foreach my $x ( 1 .. 10_000 )
        {
            my $n = $x * 49 + 1;
            my $exp =
                sum( map { calc_num_Y_in_7_consecutive_rows( $n + $_ * 7 ) }
                    0 .. $B - 1 );

            # my $got = calc_num_Y_in_7x7_consecutive_rows($n);
            my $got = $exp;
            print "x = $x :\nExpected: $exp\nGot: $got\n";
            if ( $got != $exp )
            {
                die "Failure at $n.";
            }
        }
    }
    if (0)
    {
        foreach my $x ( 1 .. 10_000 )
        {
            my $n   = $x * 7 + 1;
            my $exp = sum( map { calc_num_Y_in_row_n($_) } $n .. $n + 6 );
            my $got = calc_num_Y_in_7_consecutive_rows($n);
            print "Expected: $exp\nGot: $got\n";
            if ( $got != $exp )
            {
                die "Failure at $n.";
            }
        }
    }
}
else
{
    foreach my $n (@ARGV)
    {
        print "${n}: ",
            (
            $ENV{OPT7}
            ? calc_num_Y_in_7_consecutive_rows($n)
            : calc_num_Y_in_row_n($n)
            ),
            "\n";
    }
}
