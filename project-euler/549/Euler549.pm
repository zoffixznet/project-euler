# [[[ HEADER ]]]
use RPerl;

package Euler549;
use strict;
use warnings;
our $VERSION = 0.001_000;

# [[[ CRITICS ]]]
## no critic qw(ProhibitUselessNoCritic ProhibitMagicNumbers RequireCheckedSyscalls)  # USER DEFAULT 1: allow numeric values & print operator
## no critic qw(ProhibitStringyEval) # SYSTEM DEFAULT 1: allow eval()
## no critic qw(ProhibitConstantPragma ProhibitMagicNumbers)  # USER DEFAULT 3: allow constants
#
# [[[ CONSTANTS ]]]

use constant MAX => my integer $TYPED_MAX = 100_000_000;

# [[[ OO METHODS & SUBROUTINES ]]]

our void $run = sub {
    open my filehandleref $my_file_handle, q#-|#, 'primesieve', '-p', '2', MAX()
        or croak('foo');

    my $buf = q##;
    my integer_arrayref $primes;
    while ( my $l = <$my_file_handle> )
    {
        chomp $l;
        push @{$primes}, $l;
    }

    close $my_file_handle or croak('fluttershy');

    foreach my $p ( @{$primes} )
    {
        print "Doing p = $p\n";
        my @powers = ();
        {
            my $pow = $p;
            while ( $pow <= MAX() )
            {
                push @powers, [ $pow, $pow ];
                $pow *= $p;
            }
        }

        $powers[0][1] += $powers[0][0];
        my $this_e = 1;
        my $prev_e = 0;
        my $mul    = $p;

        foreach my $e ( 1 .. @powers )
        {
            if ( $e == $prev_e + 1 )
            {
                my $pow = $powers[ $e - 1 ][0];
                my $i   = $pow;
                while ( $i <= MAX() )
                {
                    if ( vec( $buf, $i, 32 ) < $mul )
                    {
                        vec( $buf, $i, 32 ) = $mul;
                    }
                }
                continue
                {
                    $i += $pow;
                }
            }
        }
        continue
        {
            if ( $e == $this_e )
            {
                $mul += $p;
                $prev_e = $this_e;
            INC_THIS_E:
                foreach my $p_r (@powers)
                {
                    if ( $p_r->[1] == $mul )
                    {
                        $this_e++;
                        $p_r->[1] += $p_r->[0];
                    }
                    else
                    {
                        last INC_THIS_E;
                    }
                }
            }
        }
    }

    my $sum = 0;
    foreach my $i ( 2 .. MAX() )
    {
        $sum += vec $buf, $i, 32;
    }

    print "Sum = $sum\n";

};

1;

