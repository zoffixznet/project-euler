#!/usr/bin/perl

use strict;
use warnings;

use 5.016;

my $MOD = 10000;

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
        ( $ret %= $MOD ) *= $b;
    }

    return ( $ret % $MOD );
}

foreach my $mod ( 0 .. $MOD - 1 )
{
    if ( $mod % 10 != 0 )
    {
        my $exp_MOD_mod = exp_mod( $mod, $MOD );
        my %possible_mods;
        my $m = $mod;

        while ( ( $possible_mods{$m} // 0 ) != 1 )
        {
            $possible_mods{$m}++;

            ( $m *= $mod ) %= $MOD;
        }

        my @filtered;

        foreach my $m ( sort { $a <=> $b } keys(%possible_mods) )
        {
            my %f;
            my $v = exp_mod( $mod, $m );
            while ( ( $f{$v} // 0 ) != 1 )
            {
                $f{$v}++;
                ( $v *= $exp_MOD_mod ) %= $MOD;
            }

            if ( exists( $f{$m} ) )
            {
                push @filtered, $m;
            }
        }
        print "mod=$mod --> ", join( ", ", @filtered ), "\n";

        # print "mod=$mod mod^100-mod = " , exp_mod($mod,$MOD), "\n";
    }
}

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
