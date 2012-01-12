# Description

Some useful scripts from my home directory

# Tools

* dir\_walk.pl
    * Perl script that recursively walks 2 or more directories, scanning for differences in file metadata. 
    * `./dir_walk.pl dir1 dir2 [dir3 dir4 .. dirN]`
* dispswitch.sh
    * Bash script to switch HDMI display on and off.
* find\_etc\_orphans.sh
    * Find files in `/etc` that are not own by any package (ArchLinux only).
* get\_ip.pl
    * Simple Perl script to determine internal IP address on eth0/wlan0.
* git\_diff\_wrapper
    * Wrapper to use vimdiff as the git diff tool -- set in `~/.gitconfig`
* gmail-mailto.sh
    * Script that can be set as XFCE's default e-mail handler to open mailto: links in gmail.
* pkg-clean.sh
    * Clean up pacman packages so that only latest version of each package exists per architecture. Useful on shared pacman cache.
* prettyxml.pl
    * Perl script to output an XML file or STDIN as properly formatted XML.
* pw\_gen.sh
    * Random password generator.
    * `./pw_gen.sh -n 15 [-a]`
        * -n to indicate number of characters
        * -a to indicate alpha-numeric only
* sansa-convert.sh
    * Creates videos compatible with a Sandisk Sansa e260 series mp3 player running Rockbox.
* start\_conky.sh
    * Starts my 5 conky instances.
* svn\_diff\_wrapper
    * Wrapper to use vimdiff as the svn diff tool -- set in `~/.subversion/config`
* tag-convert.sh
    * Converts ID3 tags from mp3 files to version 2.3 and renames files properly.
* tasks.sh
    * Shows task lists for conky.
* termcolors.sh
    * Displays terminal color scheme.
* touchtoggle.sh
    * Bash script to switch touchpad on and off.
* vnote2txt.pl
    * Perl script to convert a vNote file to plaintext.
