#!/usr/bin/perl
use strict;
use warnings;

if ($#ARGV != 0) {
    print "Usage: ./vnote.pl <vnote_file>\n";
    exit 1;
}

open(VNOTE, $ARGV[0]) or die "Could not open file for reading";

my $note;

while (<VNOTE>) {
    $note .= $_;
}

close VNOTE;

if (not defined $note) {
    die "Empty input file\n";
}

$note =~ /BEGIN:VNOTE\r\nVERSION:\d\.\d\r\nBODY;ENCODING=QUOTED-PRINTABLE;CHARSET=UTF-8:(.+)\r\nX-IRMC-LUID:\d\r\nDCREATED:\w+\r\nEND:VNOTE/s;
$note = $1;

if (not defined $note) {
    die "Input file not properly formatted\n";
}
$note =~ s/=0A/\n/g;
$note =~ s/=\r\n//g;

open(VNOTE, "> $ARGV[0]") or die "Could not open file for writing";
print VNOTE $note;
close VNOTE;
