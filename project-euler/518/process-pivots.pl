#!/usr/bin/perl

use strict;
use warnings;
use autodie;

use IO::All qw/ io /;
use Math::GMP ();

my %nums = ( map { ( ( $_ + 1 ) => undef ) }
        io->file("primes.txt")->chomp->getlines() );

my $total_sum = Math::GMP->new(0);
opendir my $dh, 'by-pivot-factor';
while ( my $fn = readdir($dh) )
{
    if ( my ($pivot) = $fn =~ /\A([0-9]+)\.txt\z/ )
    {
        print "Handling $pivot\n";
        open my $fh, '<', "by-pivot-factor/$fn";
        my @l = <$fh>;
        close $fh;
        chomp @l;
        my @local_n = ( map { /\A([0-9]+):/ ? $1 : () } @l );
        foreach my $r (@local_n)
        {
            my $sq = $r * $r;
            my %l = ( map { $_ => 0 } @local_n );
            foreach my $i (@local_n)
            {
                if ( $i != $r )
                {
                    if ( $sq % $i == 0 )
                    {
                        my $j = $sq / $i;
                        if ( exists( $nums{$j} ) )
                        {
                            my $is_local = exists $l{$j};
                            if ( not( $is_local and $l{$j} ) )
                            {
                                if ($is_local)
                                {
                                    $l{$j} = 1;
                                }
                                print "Found $i,$r,$j\n";
                                $total_sum += ( ( $i + $r + $j ) - 3 );
                            }
                        }
                    }
                }
            }
        }
    }
}
closedir($dh);

print "Total sum = $total_sum\n";

=head1 COPYRIGHT & LICENSE

Copyright 2017 by Shlomi Fish

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
