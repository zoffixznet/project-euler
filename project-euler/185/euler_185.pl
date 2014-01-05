#!/usr/bin/perl

use strict;
use warnings;

use integer;

my $COUNT_DIGITS = 16;
# Contents.
my $C = 0;
# Correct/True
my $T = 1;
# Remaining.
my $R = 2;

package State;

use Moo;

use List::Util qw(sum);
use List::MoreUtils qw(all any);
use List::UtilsBy qw(nsort_by);

use Storable qw(dclone);

has 'n' => (is => 'ro', required => 1);
has 'digits' => (is => 'ro', required => 1);
has 'depth' => (is => 'ro', required => 1);

use Algorithm::ChooseSubsets;

my %is_d = (map { $_ => 1 } (0 .. 9));

my @_fact = (1,1);
foreach my $n (2 .. $COUNT_DIGITS)
{
    push @_fact, $_fact[-1] * $n;
}

my @_nCr;

foreach my $sum (0 .. $COUNT_DIGITS)
{
    foreach my $x (0 .. $sum)
    {
        $_nCr[$sum][$x] = ($_fact[$sum] / ($_fact[$x] * $_fact[$sum-$x]));
    }
}

sub go
{
    my ($self) = @_;

    my $depth = $self->depth;

    my $n = [nsort_by { $_nCr[ $_->[$R] ][ $_->[$T] ] } @{ dclone($self->n()) }];

    my $d = dclone($self->digits());

    if (! @$n)
    {
        if (all { keys(%$_) == 1 } @{$self->digits()})
        {
            print "Number == ", (map { (keys%$_)[0] } @{$self->digits()}), "\n";
            exit(0);
        }
        else
        {
            die "Foobar.";
        }
    }

    my $first = shift(@$n);

    my $count = 0;
    my $v = $first->[$C];
    my @set = (grep { exists($is_d{$v->[$_]}) } (0 .. $COUNT_DIGITS - 1));
    my $iter = Algorithm::ChooseSubsets->new(
        set => \@set,
        size => $first->[$T],
    );

    my $orig_d = $d;
    my $orig_n = $n;

    SUBSETS:
    while (my $correct = $iter->next())
    {
        my %corr = (map { $_ => 1 } @$correct);
        $d = dclone($orig_d);
        $n = dclone($orig_n);

        foreach my $i (@set)
        {
            my $digit = $v->[$i];

            my $mark = sub {
                my ($true_digit) = @_;

                $d->[$i] = {$true_digit => 1};

                foreach my $num (@$n)
                {
                    my $found_digit = $num->[$C]->[$i];
                    if (exists($is_d{$found_digit}))
                    {
                        my $is_right = ($found_digit eq $true_digit);
                        $num->[$C]->[$i] = ($is_right ? 'Y' : 'N');
                        if ($is_right)
                        {
                            if ((--($num->[$T])) < 0)
                            {
                                return 1;
                            }
                        }
                        if ((--($num->[$R])) < $num->[$T])
                        {
                            return 1;
                        }
                    }
                    elsif ($found_digit eq 'Y')
                    {
                        return 1;
                    }
                }

                return;
            };

            if (exists($corr{$i}))
            {
                if ($mark->($digit))
                {
                    next SUBSETS;
                }
            }
            else
            {
                delete ($d->[$i]{$digit});
                my @k = keys(%{$d->[$i]});
                if (@k == 1)
                {
                    if ($mark->($k[0]))
                    {
                        next SUBSETS;
                    }
                }
                else
                {
                    foreach my $num (@$n)
                    {
                        my $found_digit = $num->[$C]->[$i];
                        if ($found_digit eq $digit)
                        {
                            $num->[$C]->[$i] = 'N';
                            if ((--($num->[$R])) < $num->[$T])
                            {
                                next SUBSETS;
                            }
                        }
                    }
                }
            }
        }

        # print "Depth $depth ; Count=@{[$count++]}\n";
        State->new({ n => $n, digits => $d, depth => ($depth+1)})->go;
    }

    return;
}

package main;

my $string = <<'EOF';
5616185650518293 ;2 correct
3847439647293047 ;1 correct
5855462940810587 ;3 correct
9742855507068353 ;3 correct
4296849643607543 ;3 correct
3174248439465858 ;1 correct
4513559094146117 ;2 correct
7890971548908067 ;3 correct
8157356344118483 ;1 correct
2615250744386899 ;2 correct
8690095851526254 ;3 correct
6375711915077050 ;1 correct
6913859173121360 ;1 correct
6442889055042768 ;2 correct
2321386104303845 ;0 correct
2326509471271448 ;2 correct
5251583379644322 ;2 correct
1748270476758276 ;3 correct
4895722652190306 ;1 correct
3041631117224635 ;3 correct
1841236454324589 ;3 correct
2659862637316867 ;2 correct
EOF

my @init_n = (map {
    my $l = $_;
    $l =~ /\A(\d+)/ or die "Foo";
    my $row = [split//, $1];
    my ($count_correct) = $l =~ /;(\d)/ or die "Bar";
    [$row, $count_correct, $COUNT_DIGITS,];
    }
    split(/\n/, $string)
);

my @digits = (map { +{ map { $_ => 1 } 0 .. 9 } } 0 .. $COUNT_DIGITS - 1);

my $init_state = State->new(
    {
        n => \@init_n,
        digits => \@digits,
        depth => 0,
    }
);

$init_state->go();

