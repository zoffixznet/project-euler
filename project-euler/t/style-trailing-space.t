#!/usr/bin/perl

use strict;
use warnings;

use Test::TrailingSpace ();
use Test::More tests => 1;

foreach my $path ('..')
{
    my $finder = Test::TrailingSpace->new(
        {
            root              => $path,
            filename_regex    => qr/./,
            abs_path_prune_re => qr#CMakeFiles|_Inline|(?:\.(?:xcf|patch)\z)#,
        }
    );

    # TEST*2
    $finder->no_trailing_space("No trailing whitespace was found.");
}
