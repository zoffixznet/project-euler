#!/usr/bin/perl

use strict;
use warnings;

use Math::MatrixReal;

use List::Util;

=head1 Planning.

Suppose we have n terms for which the polynomial yields (a1, a2, a3 ... an).
Then we can have:

c_0 + c_1 * 1 + c_2 * 1 ** 2 ... + c_n-1 * 1 ** n-1 = a_1
c_0 + c_1 * 2 + c_2 * 2 ** 2 ... + c_n-1 * 2 ** n-1 = a_2
c_0 + c_1 * 3 + c_2 * 3 ** 2 ... + c_n-1 * 3 ** n-1 = a_3

So we can find c_0 ... c_n-1 by solving the co-efficients problem.

=cut

sub find_coeff
{
    my ($a_s) = @_;

    my $coeffs = Math::MatrixReal->new_from_rows(
        [ map { my $x = $_; [map { $x ** $_ } (0 .. $#$a_s) ] }
            (1 .. scalar(@$a_s))
        ]
    );

    $coeffs->transpose($coeffs);

    my $a_mat = Math::MatrixReal->new_from_rows([map { [$_] } @$a_s]);

    return $coeffs->inverse() * $a_mat;
}

sub get_bop
{
    my ($a_s) = @_;

    return
    (
        Math::MatrixReal->new_from_rows([[map { @$a_s ** $_ } 1 .. scalar(@$a_s) ]])
        * find_coeff($a_s)
    )->element(1,1);
}

my @u_coeffs = (map { (-1) ** $_ } (0 .. 10));

sub calc_u_result_vec
{
    my $x = shift;

    return [map { $x ** $_ * $u_coeffs[$_] } (0 .. $#u_coeffs)];
}

sub calc_u_result
{
    my $x = shift;
    return List::Util::sum (@{calc_u_result_vec($x)});
}

my @u_results = (map { calc_u_result($_) } (1 .. scalar(@u_coeffs)));

sub get_u_bop
{
    my $i = shift;

    return get_bop( [ @u_results[0 .. $i-1] ]);
}


my $s = 0;
foreach my $i (1 .. 10)
{
    my $val = get_u_bop($i);
    print "$i : $val\n";
    $s += $val;
}
print "$s\n";
