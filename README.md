# Description

Some useful scripts from my home directory

# Tools

* dispswitch.sh
    * Bash script to switch HDMI display on and off.
* find\_etc\_orphans.sh
    * Find files in `/etc` that are not own by any package (ArchLinux only).
* git\_diff\_wrapper
    * Wrapper to use vimdiff as the git diff tool -- set in `~/.gitconfig`
* pkg-clean.sh
    * Clean up pacman packages so that only latest version of each package exists per architecture. Useful on shared pacman cache.
* prettyxml.pl
    * Perl script to output an XML file or STDIN as properly formatted XML.
* pw\_gen.sh
    * Random password generator.
    * `./pw_gen.sh -n 15 [-a]`
        * -n to indicate number of characters
        * -a to indicate alpha-numeric only
* svn\_diff\_wrapper
    * Wrapper to use vimdiff as the svn diff tool -- set in `~/.subversion/config`
* tag-convert.sh
    * Converts ID3 tags from mp3 files to version 2.3 and renames files properly.
* termcolors.sh
    * Displays terminal color scheme.
* touchtoggle.sh
    * Bash script to switch touchpad on and off.
