#!/usr/bin/perl

use strict;
use warnings;
use File::Basename;

####################
## Config options ##
####################

## What distro logo to use to use, Available "Archlinux Debian Ubuntu None" ##
my $OS = 'ArchLinux';

## What values to display ##
my %display = (
    'os'            => 1,
    'kernel'        => 1,
    'cursor'        => 1,
    'wm'            => 1,
    'win_theme'     => 1,
    'theme'         => 1,
    'icons'         => 1,
    'font'          => 1,
    'background'    => 1,
    'hostname'      => 1,
    'uptime'        => 1,
);

## Takes a screen shot if not set to 0 ##
my $shot = 0;

## Command to run to take screen shot ##
my $command = 'scrot -d 10';

## What colors to use for the variables. ##
my $textcolor = "\e[0m";

## Prints little debugging messages if set to 0 ##
my $quiet = 1;



########################
## Script starts here ##
########################
## Define some thing to work with strict ##
my @line = ();
my $DE = '';
my $WM = '';

## Hash of WMs and the process they run ##
my %WMlist = (
    'Beryl'         => 'beryl',
    'Fluxbox'       => 'fluxbox',
    'Openbox'       => 'openbox',
    'Blackbox'      => 'blackbox',
    'Xfwm4'         => 'xfwm4',
    'Metacity'      => 'metacity',
    'Kwin'          => 'kwin',
    'FVWM'          => 'fvwm',
    'Enlightenment' => 'enlightenment',
    'IceWM'         => 'icewm',
    'Window Maker'  => 'wmaker',
    'PekWM'         => 'pekwm',
);

## Hash of DEs and the process they run ##
my %DElist = (
    'Gnome' => 'gnome-session',
    'Xfce4' => 'xfce-mcs-manage',
    'KDE'   => 'ksmserver',
);

## Get Kernel version ##
if ($display{'kernel'}) {
    print "::$textcolor Finding Kernel version\n" unless $quiet;
    my $kernel = `uname -r`;
    $kernel =~ s/\s+/ /g;
    push(@line, " Kernel:       $textcolor $kernel");
}

## Get hostname ##
if ($display{'hostname'}) {
    print "::$textcolor Finding Hostname\n" unless $quiet;
    my $hostname = `hostname`;
    chomp($hostname);
    push(@line, " Hostname:     $textcolor $hostname");
}

## Get uptime ##
if ($display{'uptime'}) {
    print "::$textcolor Finding Uptime\n" unless $quiet;
    my $uptime = `uptime`;
    if ($uptime =~ /up\s+(.+),\s+\d+\s+users/) {
        push(@line, " Uptime:       $textcolor $1");
    }
}

## Find running processes ##
print "::$textcolor Getting processes \n" unless $quiet;
my $processes = `ps -A | awk {'print \$4'} | sort -u`;

## Find DE ##
while (my ($DEname, $DEprocess) = each(%DElist)) {
    print "::$textcolor Testing $DEname process: $DEprocess \n" unless $quiet;
    if ($processes =~ /$DEprocess/) {
        $DE = $DEname;
        print "::$textcolor DE found as $DE\n" unless $quiet;
        if ($display{'DE'}) {
            push(@line, " DE:           $textcolor $DE");
        }
        last;
    }
}

## Find WM ##
while (my ($WMname, $WMprocess) = each(%WMlist)) {
    print "::$textcolor Testing $WMname process: $WMprocess \n" unless $quiet;
    if ($processes =~ /$WMprocess/) {
        $WM = $WMname;
        print "::$textcolor WM found as $WM\n" unless $quiet;
        if ($display{'wm'}) {
            push(@line, " WM:           $textcolor $WM");
        }
        last;
    }
}

## Find WM theme ##
if ($display{'win_theme'}) {
    if ($WM eq 'Openbox') {
        print "::$textcolor Finding $WM theme\n" unless $quiet;
        open(FILE, "$ENV{HOME}/.config/openbox/rc.xml") or die "\e[0;31m<Failed>\n";
        while (<FILE>) {
            if (/<name>(.+)<\/name>/) {
                print "::$textcolor $WM theme found as $1\n" unless $quiet;
                push(@line, " WM Theme:     $textcolor $1");
                last;
            }
        }
        close(FILE);
    }
    elsif ($WM eq 'Metacity') {
        print "::$textcolor Finding $WM theme\n" unless $quiet;
        my $gconf = `gconftool-2 -g /apps/metacity/general/theme`;
        chomp($gconf);
        print "::$textcolor $WM theme found as $gconf\n" unless $quiet;
        push(@line, " WM Theme:     $textcolor $gconf");
    }
    elsif ($WM eq 'Fluxbox') {
        print "::$textcolor Finding $WM theme\n" unless $quiet;
        open(FILE, "$ENV{HOME}/.fluxbox/init") or die "\e[0;31m<Failed>\n";
        while (<FILE>) {
            if (/session.styleFile:.*\/(.+)/) {
                print "::$textcolor $WM theme found as $1\n" unless $quiet;
                push(@line, " WM Theme:     $textcolor $1");
            }
        }
        close(FILE);
    }
    elsif ($WM eq 'Blackbox') {
        print "::$textcolor Finding $WM theme\n" unless $quiet;
        open(FILE, "$ENV{HOME}/.blackboxrc") or die "\e[0;31m<Failed>\n";
        while (<FILE>) {
            if (/session.styleFile:.*\/(.+)/) {
                print "::$textcolor $WM theme found as $1\n" unless $quiet;
                push(@line, " WM Theme:     $textcolor $1");
            }
        }
        close(FILE);
    }
    elsif ($WM eq 'Xfwm4') {
        print "::$textcolor Finding $WM theme\n" unless $quiet;
        open(FILE, "$ENV{HOME}/.config/xfce4/mcs_settings/xfwm4.xml") or die "\e[0;31m<Failed>\n";
        while (<FILE>) {
            if (/<option name="Xfwm\/ThemeName" type="string" value="(.+)"\/>/) {
                print "::$textcolor $WM theme found as $1\n" unless $quiet;
                push(@line, " WM Theme:     $textcolor $1");
            }
        }
        close(FILE);
    }
    elsif ($WM eq 'Kwin') {
        print "::$textcolor Finding $WM theme\n" unless $quiet;
        open(FILE, "$ENV{HOME}/.kde/share/config/kwinrc") or die "\e[0;31m<Failed>\n";
        while (<FILE>) {
            if (/PluginLib=kwin3_(.+)/) {
                print "::$textcolor $WM theme found as $1\n" unless $quiet;
                push(@line, " WM Theme:     $textcolor $1");
            }
        }
        close(FILE);
    }
    elsif ($WM eq 'Enlightenment') {
        print "::$textcolor Finding $WM theme\n" unless $quiet;
        my $remote = `enlightenment_remote -theme-get theme`;
        chomp($remote);
        if ($remote =~ /.*FILE="(.+).edj"/) {
            print "::$textcolor $WM theme found as $1\n" unless $quiet;
            push(@line, " WM Theme:         $textcolor $1");
        }
    }
    elsif ($WM eq 'IceWM') {
        print "::$textcolor Finding $WM theme\n" unless $quiet;
        open(FILE, "$ENV{HOME}/.icewm/theme") or die "\e[0;31m<Failed>\n";
        while (<FILE>) {
            if (/Theme="(.+)\/.*.theme/) {
                print "::$textcolor $WM theme found as $1\n" unless $quiet;
                push(@line, " WM Theme:     $textcolor $1");
                last;
            }
        }
        close(FILE);
    }
    elsif ($WM eq 'PekWM') {
        print "::$textcolor Finding $WM theme\n" unless $quiet;
        open(FILE, "$ENV{HOME}/.pekwm/config") or die "\e[0;31m<Failed>\n";
        while (<FILE>) {
            if (/Theme.*\/(.*)"/) {
                print "::$textcolor $WM theme found as $1\n" unless $quiet;
                push(@line, " WM Theme:     $textcolor $1");
            }
        }
        close(FILE);
    }
}

## Find Theme Icon and Font ##
if ($display{'theme'} or $display{'icons'} or $display{'font'} or $display{'background'}) {
    if ($DE eq 'Gnome') {
        print "::$textcolor Finding $DE variables\n" unless $quiet;
        if ($display{'theme'}) {
            my $gconf = `gconftool-2 -g /desktop/gnome/interface/gtk_theme`;
            chomp($gconf);
            print "::$textcolor GTK Theme found as $gconf\n" unless $quiet;
            push(@line, " GTK Theme:    $textcolor $gconf");
        }
        if ($display{'icons'}) {
            my $gconf = `gconftool-2 -g /desktop/gnome/interface/icon_theme`;
            chomp($gconf);
            print "::$textcolor Icons found as $gconf\n" unless $quiet;
            push(@line, " Icons:        $textcolor $gconf");
        }
        if ($display{'font'}) {
            my $gconf = `gconftool-2 -g /desktop/gnome/interface/font_name`;
            chomp($gconf);
            print "::$textcolor Font found as $gconf\n" unless $quiet;
            push(@line, " Font:         $textcolor $gconf");
        }
        if ($display{'background'}) {
            my $gconf = `gconftool-2 -g /desktop/gnome/background/picture_filename`;
            chomp($gconf);
            my $bname = basename($gconf);
            print "::$textcolor Background found as $gconf\n" unless $quiet;
            push(@line, " Background:   $textcolor $bname");
        }

    }
    elsif ($DE eq 'Xfce4') {
        my @sort = ();
        print "::$textcolor Finding $DE variables\n" unless $quiet;
        open(FILE, "$ENV{HOME}/.config/xfce4/mcs_settings/gtk.xml") or die "\e[0;31m<Failed>\n";
        while (<FILE>) {
            if ($display{'theme'}) {
                if (/<option name="Net\/ThemeName" type="string" value="(.+)"\/>/) {
                    print "::$textcolor GTK Theme found as $1\n" unless $quiet;
                    unshift(@sort, " GTK Theme:    $textcolor $1");
                }
            }
            if ($display{'icons'}) {
                if (/<option name="Net\/IconThemeName" type="string" value="(.+)"\/>/) {
                    print "::$textcolor Icons found as $1\n" unless $quiet;
                    unshift(@sort, " Icons:        $textcolor $1");
                }
            }
            if ($display{'font'}) {
                if (/<option name="Gtk\/FontName" type="string" value="(.+)"\/>/) {
                    print "::$textcolor Font found as $1\n" unless $quiet;
                    unshift(@sort, " Font:         $textcolor $1");
                }
            }
        }
        close(FILE);
        ## Sort variables so they're ordered "Theme Icon Font" ##
        foreach my $i (@sort) {
            push(@line, $i);
        }
    }
    elsif ($DE eq 'KDE') {
        print "::$textcolor Finding $DE variables\n" unless $quiet;
        open(FILE, "$ENV{HOME}/.kde/share/config/kdeglobals") or die "\e[0;31m<Failed>\n";
        while (<FILE>) {
            if ($display{'theme'}) {
                if (/widgetStyle=(.+)/) {
                    print "::$textcolor Widget Style found as $1\n" unless $quiet;
                    push(@line, " Widget Style: $textcolor $1");
                }
                if (/colorScheme=(.+).kcsrc/) {
                    print "::$textcolor Color Scheme found as $1\n" unless $quiet;
                    push(@line, " Color Scheme: $textcolor $1");
                }
            }
            if ($display{'icons'}) {
                if (/Theme=(.+)/) {
                    print "::$textcolor Icons found as $1\n" unless $quiet;
                    push(@line, " Icons:        $textcolor $1");
                }
            }
            if ($display{'font'}) {
                if (/font=(.+)/) {
                    my $font = (split/,/, $1)[0];
                    print "::$textcolor Font found as $font\n" unless $quiet;
                    push(@line, " Font:         $textcolor $font");
                }
            }
        }
        close(FILE);

    }
    else {
        my @files = (
            "$ENV{HOME}/.gtkrc-2.0",
            "$ENV{HOME}/.gtkrc.mine",
            "$ENV{HOME}/.config/nitrogen/bg-saved.cfg",
            "$ENV{HOME}/.Xdefaults",
        );
        foreach my $file (@files) {
            if (-e $file) {
                print "::$textcolor Opening $file\n" unless $quiet;
                open(FILE, $file) or die "\e[0;31m<Failed>\n";
                while (<FILE>) {
                    if ($display{'theme'}) {
                        if (/gtk-theme-name.*"(.+)"/) {
                            print "::$textcolor GTK theme found as $1\n" unless $quiet;
                            push(@line, " GTK Theme:    $textcolor $1");
                        }
                    }
                    if ($display{'icons'}) {
                        if (/.*gtk-icon-theme-name.*"(.+)"/) {
                            print "::$textcolor Icons found as $1\n" unless $quiet;
                            push(@line, " Icons:        $textcolor $1");
                        }
                    }
                    if ($display{'font'}) {
                        if (/.*gtk-font-name.*"(.+)"/) {
                            print "::$textcolor Font found as $1\n" unless $quiet;
                            push(@line, " Font:         $textcolor $1");
                        }
                    }
                    if ($display{'background'}) {
                        if (/file=(.+)\s*/) {
                            my @bg_file = split(/\//, $1);
                            print "::$textcolor Background found as $bg_file[$#bg_file]\n" unless $quiet;
                            push(@line, " Background:   $textcolor $bg_file[$#bg_file]");
                        }
                    }
                    if ($display{'cursor'}) {
                        if (/Xcursor\.theme:\s*(.+)\s*/) {
                            print "::$textcolor Cursor found as $1\n" unless $quiet;
                            push(@line, " Cursor Theme: $textcolor $1");
                        }
                    }
                }
                close(FILE);
            }
        }
    }
}

## Display the system info ##
if ($display{'os'}) {
    my $version = $OS;
    $version =~ s/\s+/ /g;
    $version = " OS:           $textcolor $version";
    unshift(@line, $version);
}

## Prevent unitialized array value warnings ##
if ($#line < 10) {
    for (my $i = $#line; $i <= 10; $i++) {
        push(@line, '');
    }
}

my $c1 = "\e[1;34m";
my $c2 = "\e[0;34m";

system('clear');

print "
${c1}                   -`
${c1}                  .o+`
${c1}                 `ooo/
${c1}                `+oooo:
${c1}               `+oooooo:                         $c1$line[0]
${c1}               -+oooooo+:                        $c1$line[1]
${c1}             `/:-:++oooo+:                       $c1$line[2]
${c1}            `/++++/+++++++:                      $c1$line[3]
${c1}           `/++++++++++++++:                     $c1$line[4]
${c1}          `/+++${c2}ooooooooooooo/`                   $c1$line[5]
${c2}         ./ooosssso++osssssso+`                  $c1$line[6]
${c2}        .oossssso-````/ossssss+`                 $c1$line[7]
${c2}       -osssssso.      :ssssssso.                $c1$line[8]
${c2}      :osssssss/        osssso+++.               $c1$line[9]
${c2}     /ossssssss/        +ssssooo/-               $c1$line[10]
${c2}   `/ossssso+/:-        -:/+osssso+-
${c2}  `+sso+:-`                 `.-/+oso:
${c2} `++:.                           `-/+/
${c2} .`                                  ``\e[0m\n\n";

if ($shot) {
    system($command);
}
