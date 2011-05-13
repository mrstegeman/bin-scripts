#!/usr/bin/perl

use strict;

my $int_ip;
my $eth0 = `ifconfig eth0`;
$eth0 =~ m/inet\saddr:([0-9.]{7,15})/gs;
if ( $1 ) { $int_ip = $1; }
else {
    my $wlan0 = `ifconfig wlan0`;
    $wlan0 =~ m/inet\saddr:([0-9.]{7,15})/gs;
    if ( $1 ) { $int_ip = $1; }
}

print $int_ip;
