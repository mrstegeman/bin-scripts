#!/usr/bin/perl

use strict;
use warnings;

use Cwd;
use File::Find;

our %file_tree = ();
our %new_files = ();
our $work_dir = '';
our $orig_dir = $ARGV[0] or print "Usage: ./dir_walk.pl dir1 dir2 [dir3 dir4 .. dirN]\n" and exit;
$orig_dir =~ s/\/$//;
our @stat_meta = qw(dev ino mode nlink uid gid rdev size atime mtime ctime blksize blocks);

find(\&build_tree, $orig_dir);

# loop over directories given on command line
my $i;
for ($i = 1; $i <= $#ARGV; $i++) {
    $work_dir = $ARGV[$i];
    $work_dir =~ s/\/$//;
    &add_dir();
    find(\&compare, $ARGV[$i]);
}
print "Usage: ./dir_walk.pl dir1 dir2 [dir3 dir4 .. dirN]\n" and exit if $i == 1;

&summary_to_html();


# build hash of original files
sub build_tree {
    my $name = $File::Find::name;
    my $full_name = getcwd() . "/$_";
    my $rel_name = $name;

    # get relative filename
    if ($rel_name eq $orig_dir) {
        return;
    }
    else {
        my $len = length($orig_dir);
        $rel_name =~ s/^.{$len}\///;
    }

    if (-d $full_name) {
        $rel_name .= '/';
    }

    # get inode metatdata
    my @st = stat($full_name);
    $file_tree{$rel_name}{'stat_arr'} = \@st;
}

# add a new directory hash for each file in tree
sub add_dir {
    while (my ($k, $v) = each %file_tree) {
        $file_tree{$k}{$work_dir}{'exists'} = 0;
    }
}

# compare file to original file tree
sub compare {
    my $name = $File::Find::name;
    my $full_name = getcwd() . "/$_";
    my $rel_name = $name;

    # get relative filename
    if ($rel_name eq $work_dir) {
        return;
    }
    else {
        my $len = length($work_dir);
        $rel_name =~ s/^.{$len}\///;
    }

    if (-d $full_name) {
        $rel_name .= '/';
    }

    my @st = stat($full_name);

    # checking for existence in original directory
    if ($file_tree{$rel_name}) {
        $file_tree{$rel_name}{$work_dir}{'exists'} = 1;
    }
    # new file -- put in new file hash
    else {
        if ($new_files{$rel_name}) {
            push @{$new_files{$rel_name}}, $work_dir;
        }
        else {
            my @arr = ($work_dir);
            $new_files{$rel_name} = \@arr;
        }
        return;
    }

    # check inode metadata
    my @orig_stat = @{$file_tree{$rel_name}{'stat_arr'}};
    foreach (my $i = 0; $i <= $#st; $i++) {
        # if stat has changed, append to changes array
        if ($orig_stat[$i] != $st[$i] and not
            ($stat_meta[$i] eq 'atime' or
             $stat_meta[$i] eq 'ctime' or
             $stat_meta[$i] eq 'mtime' or
             $stat_meta[$i] eq 'dev' or
             $stat_meta[$i] eq 'ino')) {

            if ($file_tree{$rel_name}{$work_dir}{'changes'}) {
                push @{$file_tree{$rel_name}{$work_dir}{'changes'}}, $stat_meta[$i];
            }
            else {
                my @arr = ($stat_meta[$i]);
                $file_tree{$rel_name}{$work_dir}{'changes'} = \@arr;
            }
        }
    }
}

sub summary_to_html {
    my $html1 = <<END;
<html>
    <head>
        <title>Directory Summary</title>
        <style type="text/css">
            table, th, td {font-size:8pt;font-family:arial;margin:10px 0 15px;text-align:left;border:1px solid #CDCDCD;}
            th {background-color:#E6EEEE;padding:4px;}
            td {padding:4px;}
            table {width:100%;border-collapse:collapse;}
        </style>
    </head>
    <body>
        <div>
            <h3>File Changes</h3>
            <table>
                <thead>
                    <tr>
                        <th>File</th>
END

    for (my $i = 1; $i <= $#ARGV; $i++) {
        my $dir = $ARGV[$i];
        $dir =~ s/\/$//;
        $html1 .= "                        <th>$dir</th>\n";
    }
    $html1 .= "                    </tr>\n";
    $html1 .= "                </thead>\n";
    $html1 .= "                <tbody>\n";

    # loop over files in tree
    my $k;
    foreach $k (sort keys %file_tree) {
        $html1 .= "                    <tr>\n";
        $html1 .= "                        <td>$k</td>";
        # loop over directories specified on command line
        for (my $i = 1; $i <= $#ARGV; $i++) {
            my $dir = $ARGV[$i];
            $dir =~ s/\/$//;
            # if file exists in directory and has changes, output changes
            if ($file_tree{$k}{$dir}{'exists'} == 1 and $file_tree{$k}{$dir}{'changes'}) {
                $html1 .= "<td>";
                foreach (@{$file_tree{$k}{$dir}{'changes'}}) {
                    $html1 .= "$_ ";
                }
                $html1 .= "</td>";
            }
            # else if file doesn't exist, output missing
            elsif ($file_tree{$k}{$dir}{'exists'} == 0) {
                $html1 .= "<td>missing</td>";
            }
            # else output blank table data
            else {
                $html1 .= "<td></td>";
            }
        }
        $html1 .= "\n                    </tr>\n";
    }

    $html1 .= "                </tbody>\n";
    $html1 .= "            </table>\n";

    # remove all rows with no changes/missing files
    $html1 =~ s/\s+<tr>\s+<td>.*?<\/td>(<td><\/td>)+\s+<\/tr>//mg;

    my $html2 = <<END;
            <br />
            <h3>New Files</h3>
            <table>
                <thead>
                    <tr>
                        <th>File</th>
END

    for (my $i = 1; $i <= $#ARGV; $i++) {
        my $dir = $ARGV[$i];
        $dir =~ s/\/$//;
        $html2 .= "                        <th>$dir</th>\n";
    }

    $html2 .= "                    </tr>\n";
    $html2 .= "                </thead>\n";
    $html2 .= "                <tbody>\n";

    # loop over hash of new files
    foreach $k (sort keys %new_files) {
        $html2 .= "                    <tr>\n";
        $html2 .= "                        <td>$k</td>";
        # loop over directories listed on command line
        for (my $i = 1; $i <= $#ARGV; $i++) {
            my $dir = $ARGV[$i];
            $dir =~ s/\/$//;
            # if file exists in current directory, output a check mark
            if (exists {map { $_ => 1 } @{$new_files{$k}}}->{$dir}) {
                $html2 .= "<td>&#10003;</td>";
            }
            # else output blank table data
            else {
                $html2 .= "<td></td>";
            }
        }
        $html2 .= "\n                    </tr>\n";
    }

    $html2 .= "                </tbody>\n";
    $html2 .= "            </table>\n";
    $html2 .= "        </div>\n";
    $html2 .= "    </body>\n";
    $html2 .= "</html>\n";

    print $html1, $html2;
}
