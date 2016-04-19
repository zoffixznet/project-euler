#!/usr/bin/perl

use strict;
use warnings;

use IO::All qw/ io /;
use 5.022;

my $fn = shift@ARGV;

my $text = io->file($fn)->utf8->all;

$text =~ s#^=head1 DESCRIPTION\n+(.*?)(?=^=)(?:=cut)?##ms;

my $out = $1;

my $d_fn = $fn =~ s#(?:-v[0-9]+)?\.pl\z#-description.txt#msr;

io->file($fn)->utf8->print($text);
io->file($d_fn)->utf8->print($out);

system("git", "add", $fn, $d_fn);
