#!/usr/bin/perl

use strict;
use warnings;

=head1 DESCRIPTION

By using each of the digits from the set, {1, 2, 3, 4}, exactly once, and making use of the four arithmetic operations (+, −, *, /) and brackets/parentheses, it is possible to form different positive integer targets.

For example,

8 = (4 * (1 + 3)) / 2
14 = 4 * (3 + 1 / 2)
19 = 4 * (2 + 3) − 1
36 = 3 * 4 * (2 + 1)

Note that concatenations of the digits, like 12 + 34, are not allowed.

Using the set, {1, 2, 3, 4}, it is possible to obtain thirty-one different target numbers of which 36 is the maximum, and each of the numbers 1 to 28 can be obtained before encountering the first non-expressible number.

Find the set of four distinct digits, a < b < c < d, for which the longest set of consecutive positive integers, 1 to n, can be obtained, giving your answer as a string: abcd.

=cut

use IO::Handle;
use Data::Dumper;

STDOUT->autoflush(1);

my %op_funcs = (
    '+' => sub { $_[0]+$_[1] },
    '-' => sub { $_[0]-$_[1] }, 
    '*' => sub { $_[0]*$_[1] },
    '/' => sub { return (($_[1]+0 != 0) ? ($_[0]/$_[1]) : undef); },
);

sub recurse_op
{
    my ($op, $rest) = @_;

    my %ret;

    my $cb = $op_funcs{$op};

    if (@$rest == 4)
    {
        foreach my $e1 (0 .. 2)
        {
            foreach my $e2 ($e1+1 .. 3)
            {
                my $s1 = recurse([@$rest[$e1,$e2]]);
                my $s2 = recurse([@$rest[
                    grep { ($_ != $e1) && ($_ != $e2) } (0 .. $#$rest)
                ]]);

                foreach my $k1 (keys(%$s1))
                {
                    foreach my $k2 (keys(%$s2))
                    {
                        foreach my $v (
                            $cb->($k1, $k2), 
                            $cb->($k2, $k1)
                        )
                        {
                            if (defined($v))
                            {
                                $ret{$v} = 1;
                            }
                        }
                    }
                }
            }
        }
    }

    foreach my $alone (0 .. $#$rest)
    {
        my $calc = recurse([@$rest[grep { $_ != $alone} (0 .. $#$rest)]]);
        foreach my $k (keys(%$calc))
        {
            foreach my $v (
                $cb->($k, $rest->[$alone]), 
                $cb->($rest->[$alone], $k)
            )
            {
                if (defined($v))
                {
                    $ret{$v} = 1;
                }
            }
        }
    }

    return \%ret;
}

sub recurse
{
    my ($rest) = @_;
 
    if (@$rest == 1)
    {
        return { $rest->[0] => 1 };
    }
    
    my %ret;
    foreach my $op (qw(+ - / *))
    {
        %ret = (%ret, %{recurse_op($op, $rest)});
    }

    return \%ret;
}

my @max_n;
my $max_n_seq_len = 0;

print Dumper(recurse([1,2,3,4]));

foreach my $x (0 .. 6)
{
    foreach my $y ($x+1 .. 7)
    {
        foreach my $z ($y+1 .. 8)
        {
            foreach my $t ($z+1 .. 9)
            {
                my @n = ($x,$y,$z,$t);
                
                my $ret = recurse(\@n);

                my $seq_len = 1;
                while (exists($ret->{$seq_len}))
                {
                    $seq_len++;
                }
                $seq_len--;
                
                if ($seq_len > $max_n_seq_len)
                {
                    @max_n = @n;
                    $max_n_seq_len = $seq_len;
                    print "Found @max_n with $max_n_seq_len\n";
                }
            }
        }
    }
}
