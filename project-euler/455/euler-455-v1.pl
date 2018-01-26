#!/usr/bin/perl

use strict;
use warnings;
use autodie;

use 5.016;

use integer;
use bytes;

my $MOD = 1_000_000_000;

sub exp_mod
{
    my ( $b, $e ) = @_;

    if ( $e == 0 )
    {
        return 1;
    }

    my $rec_p = exp_mod( $b, ( $e >> 1 ) );

    my $ret = $rec_p * $rec_p;

    if ( $e & 0x1 )
    {
        $ret *= $b;
    }

    return ( $ret % $MOD );
}

# my $START = $MOD-1;
my $START   = 999997951;
my $SEGMENT = 1024;

my $DUMP_FN = 'euler-455.txt';

my $sum = 0;

# Every n^e where e > 2 will have more zeros than needed.
my @n_s = ( grep { $_ % 10 != 0 } ( 2 .. 1_000_000 ) );

{
    my %blacklist;
    open my $in, '<', $DUMP_FN;
    while ( my $l = <$in> )
    {
        chomp($l);
        if ( my ( $x, $n ) = $l =~ /\AFound x=(\d+) for n=(\d+)\z/ )
        {
            $sum += $x;
            $blacklist{$n} = 1;
        }
        elsif ( my ($reached) = $l =~ /\AInspecting (\d+)/ )
        {
            $START = $reached;
        }
    }
    close($in);

    @n_s = grep { !exists( $blacklist{$_} ) } @n_s;
}

STDOUT->autoflush(1);

my $range_top = $START;

open my $out_fh, '>>', $DUMP_FN;
$out_fh->autoflush(1);
while ( $range_top > $SEGMENT )
{
    say {$out_fh} "Inspecting $range_top";
    my $bottom = $range_top - ( $SEGMENT - 1 );

    my @next_n_s;
    for my $n (@n_s)
    {
        my $e = $bottom;
        my $m = exp_mod( $n, $e );
        my $found_e;
        while ( $e <= $range_top )
        {
            if ( $m == $e )
            {
                $found_e = $e;
            }
            $m = ( ( $m * $n ) % $MOD );
        }
        continue
        {
            $e++;
        }

        if ( defined($found_e) )
        {
            say {$out_fh} "Found x=$found_e for n=$n";
            $sum += $found_e;
        }
        else
        {
            push @next_n_s, $n;
        }
    }
    @n_s = @next_n_s;
}
continue
{
    $range_top -= $SEGMENT;
}
close($out_fh);
say "Sum == $sum";

__END__

=begin FOO

sub func
{
    my ($n) = @_;

    my $e = 1;
    my $m = $n;

    my $found_e;

    while (($e < $MOD) && ($m != 1))
    {
        print "E=$e M=$m\n";
        if ($m == 0)
        {
            return 0;
        }
        elsif ($m == $n)
        {
            $found_e = $e;
        }
    }
    continue
    {
        $e++;
        $m = (($m * $n) % $MOD);
    }

    if ($e == $MOD or (!defined($found_e)))
    {
        return 0;
    }
    else
    {
        my $div = ($MOD / $e);
        my $mod = ($MOD % $e);

        return (($div - ($mod > $found_e)) *$e + $found_e);
    }
}

=end FOO

=head1 COPYRIGHT & LICENSE

Copyright 2018 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

=cut
