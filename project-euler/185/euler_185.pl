#!/usr/bin/perl

use strict;
use warnings;

use integer;


my $COUNT_DIGITS = 16;
my $string = <<'EOF'
2321386104303845 ;0 correct
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
    }
);

$init_state->go();

package State;

use Moo;
use MooX qw(late);

use List::Util qw(sum);
use List::MoreUtils qw(all);

has 'n' => (isa => 'ArrayRef[HashRef]', is => 'ro');
has 'digits' => (isa => 'ArrayRef[HashRef]', is => 'ro');

sub go
{
    my ($self) = @_;

    if (all { @$_ == 1 } @{$self->digits()})
    {
        print "Number == ", (map { (keys%$_)[0] } @{$self->digits()}), "\n";
        exit(0);
    }

    my @n = (sort { $a->{correct} <=> $b->{correct}
            or
        $a->{remaining} <=> $b->{remaining}
        } @{$self->n};

    my $first = shift(@n);
    if ($first->{correct} == 0)
    {

    }
}

1;
