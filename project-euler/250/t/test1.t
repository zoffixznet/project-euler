#!/usr/bin/perl

use strict;
use warnings;

use autodie;

use Test::More tests => 12;

sub my_test
{
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    my ($MOD, $MAX, $blurb) = @_;

    my $prefix = qq#MOD="$MOD" MAX="$MAX" #;
    system("$prefix perl euler-250-v1-step1.pl > mod_counts.txt");
    system("$prefix perl euler-250-v1-step2.bash < mod_counts.txt > mod_groups.txt");

    my ($got) = `$prefix python euler_250_v1_step3.py` =~ /^Final result = ([0-9]+)$/ms
        or die "Not found.";
    my ($want) = `$prefix /home/shlomif/Download/unpack/prog/python/pypy2-v5.3.0-src/pypy/goal/pypy-c euler_250_v1_step3_brute_force.py` =~ /^Num = ([0-9]+)/ms
        or die "brute not found.";

    return is($got, $want, "$prefix $blurb");
}

{
    # TEST
    my_test(2, 2, "2;2");
    # TEST
    my_test(2, 3, "2;3");
    # TEST
    my_test(2, 4, "2;4");
    # TEST
    my_test(2, 5, "2;5");
    # TEST
    my_test(2, 6, "2;6");
    # TEST
    my_test(3, 3, "3;3");
    # TEST
    my_test(3, 4, "3;4");
    # TEST
    my_test(3, 5, "3;5");
    # TEST
    my_test(3, 6, "3;6");
    # TEST
    my_test(3, 7, "3;7");
    # TEST
    my_test(4, 4, "4;4");
    # TEST
    my_test(4, 5, "4;5");
}

