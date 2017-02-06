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
                            if ( $is_local and $l{$j} )
                            {
                            }
                            else
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
