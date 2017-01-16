#!/usr/bin/perl

use strict;
use warnings;

my $sum = 0;

sub check
{
    my ($verdicts) = @_;

    $sum += ( 1 << ( ( 1 << 6 ) - scalar( keys(%$verdicts) ) ) );
}

sub recurse
{
    my ( $abc, $verdicts ) = @_;

    print "recurse: $abc\n";
    if ( $abc == ( 1 << 3 ) )
    {
        check($verdicts);
        return;
    }

    my @abc;

    my $n = $abc;
    for my $p ( 0 .. 2 )
    {
        push @abc, ( $n & 0x1 );
        $n >>= 1;
    }

    my $last_abc = 0 + ( $abc[0] ^ ( $abc[1] & $abc[2] ) );

    my $def_recurse;

    $def_recurse = sub {
        my ( $def, $verdicts ) = @_;

        my @def;

        my $n = $def;
        for my $p ( 0 .. 2 )
        {
            push @def, ( $n & 0x1 );
            $n >>= 1;
        }
        if ( $def == ( 1 << 3 ) )
        {
            recurse( $abc + 1, $verdicts );
            return;
        }

    TRUTH:
        foreach my $truth ( [ 0, 0 ], [ 0, 1 ], [ 1, 0 ] )
        {
            my @nums = ( [ @abc, @def ], [ @abc[ 1, 2 ], @def, $last_abc ] );

            my $new_verdicts = {%$verdicts};

            foreach my $p ( 0, 1 )
            {
                my $s = join '', @{ $nums[$p] };
                if ( exists( $new_verdicts->{$s} )
                    and $new_verdicts->{$s} != $truth->[$p] )
                {
                    next TRUTH;
                }
                $new_verdicts->{$s} = $truth->[$p];
            }
            $def_recurse->( ( $def + 1 ), $new_verdicts );
        }
    };

    $def_recurse->( 0, $verdicts );

    return;
}

recurse( 0, {} );

print "Sum == $sum\n";
