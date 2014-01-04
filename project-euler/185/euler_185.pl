#!/usr/bin/perl

use strict;
use warnings;

use integer;

my $COUNT_DIGITS = 16;

package State;

use Moo;
use MooX qw(late);

use List::Util qw(sum);
use List::MoreUtils qw(all any);

use Storable qw(dclone);

has 'n' => (isa => 'ArrayRef[HashRef]', is => 'ro', required => 1);
has 'digits' => (isa => 'ArrayRef[HashRef]', is => 'ro', required => 1);
has 'depth' => (isa => 'Int', is => 'ro', required => 1);

use Algorithm::ChooseSubsets;

my %is_d = (map { $_ => 1 } (0 .. 9));

sub go
{
    my ($self) = @_;

    my $depth = $self->depth;

    my $n = [sort { $a->{correct} <=> $b->{correct}
            or
        ($a->{remaining} <=> $b->{remaining})
        } @{ dclone($self->n()) }];

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

    if (($first->{correct} < 0) or
        (any { $_->{correct} > $_->{remaining} } (@$n, $first))
    )
    {
        # Dead end - cannot be.
        return;
    }

=begin foo
    if ($first->{correct} == 0)
    {
        I_LOOP1:
        for my $i (0 .. $COUNT_DIGITS - 1)
        {
            my $digit = $first->{contents}[$i];

            if ($digit eq 'Y')
            {
                # Cannot be.
                next I_LOOP1;
            }
            elsif ($digit ne 'N')
            {
                if (! exists($d->[$i]{$digit}))
                {
                    # Cannot be.
                    return;
                }
                else
                {
                    delete ($d->[$i]{$digit});
                    my $true_digit;
                    if (keys(%{$d->[$i]}) == 1)
                    {
                        ($true_digit) = keys(%{$d->[$i]});
                    }
                    foreach my $num (@$n)
                    {
                        my $found_digit = $num->{contents}->[$i];
                        if ($found_digit =~ /\A[0-9]\z/)
                        {
                            if (defined($true_digit) ? ($found_digit != $true_digit) : ($found_digit == $digit))
                            {
                                $num->{contents}->[$i] = 'N';
                                $num->{remaining}--;
                            }
                            elsif (defined($true_digit) && ($found_digit == $true_digit))
                            {
                                $num->{contents}->[$i] = 'Y';
                                $num->{correct}--;
                                $num->{remaining}--;
                            }
                        }
                    }
                }
            }
        }
        return State->new({ n => $n, digits => $d})->go;
    }

    else

=end foo

=cut

    {
        my $count = 0;
        my $v = $first->{contents};
        my @set = (grep { exists($is_d{$v->[$_]}) } (0 .. $COUNT_DIGITS - 1));
        my $iter = Algorithm::ChooseSubsets->new(
            set => \@set,
            size => $first->{correct}
        );

        my $orig_d = $d;
        my $orig_n = $n;

        SUBSETS:
        while (my $correct = $iter->next())
        {
            my %corr = (map { $_ => 1 } @$correct);
            $d = dclone($orig_d);
            $n = dclone($orig_n);

            for my $i (@set)
            {
                my $digit = $v->[$i];

                my $mark = sub {
                    my ($true_digit) = @_;
                    $d->[$i] = {$true_digit => 1};
                    foreach my $num (@$n)
                    {
                        my $found_digit = $num->{contents}->[$i];
                        if (exists($is_d{$found_digit}))
                        {
                            my $is_right = ($found_digit == $true_digit);
                            $num->{contents}->[$i] = ($is_right ? 'Y' : 'N');
                            $num->{remaining}--;
                            if ($is_right)
                            {
                                $num->{correct}--;
                            }
                        }
                        elsif ($found_digit eq 'Y')
                        {
                            next SUBSETS;
                        }
                    }
                };

                if (exists($corr{$i}))
                {
                    $mark->($digit);
                }
                else
                {
                    delete ($d->[$i]{$digit});
                    my @k = keys(%{$d->[$i]});
                    if (@k == 1)
                    {
                        $mark->($k[0]);
                    }
                    else
                    {
                        foreach my $num (@$n)
                        {
                            my $found_digit = $num->{contents}->[$i];
                            if ($found_digit eq $digit)
                            {
                                $num->{contents}->[$i] = 'N';
                                if ((--$num->{remaining}) < $num->{correct})
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
    my @row = split//, $1;
    my ($count_correct) = $l =~ /;(\d)/ or die "Bar";
    +{
        contents => [@row],
        correct => $count_correct,
        remaining => $COUNT_DIGITS,
    },
    } split(/\n/, $string)
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

