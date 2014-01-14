#!/usr/bin/perl

use strict;
use warnings;

=head1 DESCRIPTION

Working from left-to-right if no digit is exceeded by the digit to its left it is called an increasing number; for example, 134468.

Similarly if no digit is exceeded by the digit to its right it is called a decreasing number; for example, 66420.

We shall call a positive integer that is neither increasing nor decreasing a "bouncy" number; for example, 155349.

Clearly there cannot be any bouncy numbers below one-hundred, but just over half of the numbers below one-thousand (525) are bouncy. In fact, the least number for which the proportion of bouncy numbers first reaches 50% is 538.

Surprisingly, bouncy numbers become more and more common and by the time we reach 21780 the proportion of bouncy numbers is equal to 90%.

Find the least number for which the proportion of bouncy numbers is exactly 99%.

=cut

my @counts = (0,0);
for (my $n = 1; ; $n++)
{
    my $s = join "",sort { $a <=> $b } split//,$n;

    $counts[($n eq $s) || ($n eq scalar(reverse($s))) || 0]++;

=begin foo
    if ($n == 538)
    {
        print "@counts\n";
    }
=end foo

=cut

    if ($n % 100_000 == 0)
    {
        print "$n: @counts\n"
    }

    if ($counts[1] * 100 == $n)
    {
        print "Least n = $n\n";
        exit(0);
    }
}
