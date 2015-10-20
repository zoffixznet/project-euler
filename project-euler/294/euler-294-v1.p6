#!perl6

use v6;

my $RESULT_MOD = 1_000_000_000;
my $DIGITS_SUM = 23;
my $BASE = 23;
my $HIGH_MOD = $BASE - 1;

sub _new
{
    return map { [(0) xx $BASE] }, (0 .. $DIGITS_SUM);
}

my @rec0 = _new();
@rec0[0][0] = 1;
my %for_n = (0 => @rec0,);

sub exp_mod($MOD, $b, $e)
{
    if ($e == 0)
    {
        return 1;
    }

    my $rec_p = exp_mod($MOD, $b, ($e +> 1));

    my $ret = $rec_p * $rec_p;

    if ($e +& 0x1)
    {
        $ret *= $b;
    }

    return ($ret % $MOD);
}

sub inc($n, @old_rec)
{
    my $BASE_MOD = exp_mod($BASE, 10, $n+1);

    my @new_rec = _new();

    for @old_rec.kv -> $old_digits_sum, $old_mod_counts
    {
        for 0..min(9, $DIGITS_SUM-$old_digits_sum) -> $new_digit
        {
            for $old_mod_counts.kv -> $old_mod , $old_count
            {
                ((@new_rec[$old_digits_sum + $new_digit][
                    ($old_mod + $BASE_MOD * $new_digit) % $BASE
                ]) += $old_count)
                %= $RESULT_MOD;
            }
        }
    }

    return @new_rec;
}

sub double($n, @old_rec)
{
    my $BASE_MOD = exp_mod($BASE, 10, $n);

    my @new_rec = _new();

    # ds == digits_sum
    for 0 .. $DIGITS_SUM -> $low_ds
    {
        my $low_mod_counts = @old_rec[$low_ds];

        for 0 .. $HIGH_MOD -> $low_mod
        {
            my $low_count = $low_mod_counts[$low_mod];

            for 0 .. $DIGITS_SUM-$low_ds -> $high_ds
            {
                my $high_mod_counts = @old_rec[$high_ds];

                for 0 .. $HIGH_MOD -> $proto_high_mod
                {
                    my $high_count = $high_mod_counts[$proto_high_mod];

                    ((@new_rec[
                                $low_ds + $high_ds
                            ][
                                ($low_mod + $BASE_MOD * $proto_high_mod)
                                %
                                $BASE
                            ]) += ($high_count * $low_count))
                    %= $RESULT_MOD
                    ;

                }
            }
        }
    }

    return @new_rec;
}

sub calc($n)
{
    return %for_n{$n} //= do {
        my %rec = ($n +& 0x1) ?? ('x' => ($n-1), 'cb' => &inc)
            !! ( 'x' => ($n +> 1), 'cb' => &double );
        my $x = %rec{'x'};
        %rec{'cb'}($x, calc($x));
    };
}

sub lookup($n)
{
    return calc($n)[$DIGITS_SUM][0];
}

print "Result[9] = {lookup(9)}\n";
print "Result[42] = {lookup(42)}\n";

my $SOUGHT_EXPR = '11 ** 12';
my $SOUGHT = EVAL( $SOUGHT_EXPR );

print "Result[$SOUGHT_EXPR] = {lookup($SOUGHT)}\n";
