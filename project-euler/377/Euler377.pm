package Euler377;

use strict;
use warnings;

use integer;
use bytes;

our $NUM_DIGITS = 10;
our $MAX_DIGIT = $NUM_DIGITS - 1;
our @DIGITS = (0 .. $MAX_DIGIT);

sub gen_empty_matrix
{
    return [map { [ map { 0 } @DIGITS] } @DIGITS];
}

our $BASE = 13;

our @N_s = ($BASE);

for my $i (2 .. 17)
{
    push @N_s, $N_s[-1] * $BASE;
}

my %mult_cache;

sub calc_multiplier
{
    my ($sum) = @_;

    return ($mult_cache{$sum} //= sub {
            return 200;
    }->());
}

sub recurse_digits
{
    my ($count, $digits, $sum) = @_;

    if ($count == $MAX_DIGIT)
    {
        print "Trace: ", (map { ($_->[0]) x $_->[1] } @$digits), "\n";
        my $multiplier = calc_multiplier($sum);

        my $digit_base = 0;

        return 0;
    }
    else
    {
        my ($last_digit, $last_digit_count) = @{$digits->[-1]};

        my $ret = 0;

        $ret += recurse_digits($count+1, [
                @$digits[0 .. $#$digits-1],
                [$last_digit, $last_digit_count+1],
            ],
            $sum + $last_digit
        );

        $ret %= 1_000_000_000;

        foreach my $new_digit ($last_digit + 1 .. 9)
        {
            $ret += recurse_digits(
                $count+1,
                [@$digits, [$new_digit, 1]],
                $sum + $new_digit,
            );
            $ret %= 1_000_000_000;
        }

        return $ret;
    }
}

sub calc_result_above
{
    my $result = 0;
    foreach my $new_digit (1 .. 9)
    {
        $result += recurse_digits(
            1,
            [[$new_digit, 1]],
            $new_digit,
        );
        $result %= 1_000_000_000;
    }

    return $result;
}

1;
