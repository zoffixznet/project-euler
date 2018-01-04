#!/usr/bin/perl

use strict;
use warnings;

use List::MoreUtils qw/ any /;
use List::Util qw/ max /;

sub run
{
    my $input = shift;

    my @table = (
        map {
            [ map { int } $_ =~ /([0-9]+)/g ]
        } split /\r?\n/,
        $input
    );

    my $width = @table;

    if ( any { @$_ != $width } @table )
    {
        die "wrong input";
    }

    my @cache;

    my $rec;

    $rec = sub {
        my ($n) = @_;

        return $cache[$n] //= sub {
            my $as_bin = scalar reverse sprintf( '%b', $n );
            my $num_bits = $as_bin =~ y/1/1/;
            if ( $num_bits == 1 )
            {
                return $table[0][ index( $as_bin, '1' ) ];
            }
            my @pos =
                ( grep { substr $as_bin, $_, 1 eq '1' } 0 .. length $as_bin );
            return max(
                map {
                    my $this_pos = $_;
                    my $new      = ( $n & ( ~( 1 << $this_pos ) ) );
                    my $v1       = $rec->($new);
                    if ( !defined $v1 )
                    {
                        die "foob $n new=$new";
                    }
                    my $v2 = $table[ $num_bits - 1 ][$this_pos];
                    if ( !defined $v2 )
                    {
                        die "elma $n";
                    }
                    $v1 + $v2;
                } @pos
            );
            }
            ->();
    };

    return $rec->( ( 1 << ($width) ) - 1 );
}

print "run for 5 == ", run(<<'EOF'), "\n";
     7  53 183 439 863
     497 383 563  79 973
     287  63 343 169 583
     627 343 773 959 943
     767 473 103 699 303
EOF

print "production run for 15 == ", run(<<'EOF'), "\n";
  7  53 183 439 863 497 383 563  79 973 287  63 343 169 583
627 343 773 959 943 767 473 103 699 303 957 703 583 639 913
447 283 463  29  23 487 463 993 119 883 327 493 423 159 743
217 623   3 399 853 407 103 983  89 463 290 516 212 462 350
960 376 682 962 300 780 486 502 912 800 250 346 172 812 350
870 456 192 162 593 473 915  45 989 873 823 965 425 329 803
973 965 905 919 133 673 665 235 509 613 673 815 165 992 326
322 148 972 962 286 255 941 541 265 323 925 281 601  95 973
445 721  11 525 473  65 511 164 138 672  18 428 154 448 848
414 456 310 312 798 104 566 520 302 248 694 976 430 392 198
184 829 373 181 631 101 969 613 840 740 778 458 284 760 390
821 461 843 513  17 901 711 993 293 157 274  94 192 156 574
 34 124   4 878 450 476 712 914 838 669 875 299 823 329 699
815 559 813 459 522 788 168 586 966 232 308 833 251 631 107
813 883 451 509 615  77 281 613 459 205 380 274 302  35 805
EOF
