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
