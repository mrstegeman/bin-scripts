#!/usr/bin/perl

use XML::Twig;
use XML::Parser;

my $xml = XML::Twig->new(pretty_print => 'indented');

if ($ARGV[0]) {
    if (-r $ARGV[0]) {
        open(F, "<$ARGV[0]");
        $xml->parse(\*F);
        close(F);
    }
    else {
        print("invalid filename\n");
        exit(1);
    }
} else {
    $xml->parse(\*STDIN);
}

$xml->print();
