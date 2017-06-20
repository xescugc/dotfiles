#!/usr/bin/env perl
# vim:ts=4:sw=4:expandtab
# © 2012 Michael Stapelberg, Public Domain

# This script is a simple wrapper which prefixes each i3status line with custom
# information. To use it, ensure your ~/.i3status.conf contains this line:
#     output_format = "i3bar"
# in the 'general' section.
# Then, in your ~/.i3/config, use:
#     status_command i3status | ~/i3status/contrib/wrapper.pl
# In the 'bar' section.

use strict;
use warnings;
# You can install the JSON module with 'cpan JSON' or by using your
# distribution’s package management system, for example apt-get install
# libjson-perl on Debian/Ubuntu.
use JSON;

# Don’t buffer any output.
$| = 1;

# Skip the first line which contains the version header.
print scalar <STDIN>;

# The second line contains the start of the infinite array.
print scalar <STDIN>;

# Read lines forever, ignore a comma at the beginning if it exists.
while (my ($statusline) = (<STDIN> =~ /^,?(.*)/)) {
    # Decode the JSON-encoded line.
    my @blocks = @{decode_json($statusline)};

    # Prefix our own information (you could also suffix or insert in the
    # middle).

    my $mem = `awk '/MemTotal/ {memtotal=\$2}; /MemAvailable/ {memavail=\$2}; END { printf("%.0f", (100- (memavail / memtotal * 100))) }' /proc/meminfo`;
    #my $mem = `awk '/MemTotal/ {memtotal=\$2}; /MemAvailable/ {memavail=\$2}; /Cached/ {memcached=\$2}; END { printf("%.0f", (100- ((memavail-memcached) / memtotal * 100))) }' /proc/meminfo`;

    my $color = '#d0d0d0';
    if ($mem > 70) {
        $color = '#ff0090';
    }
    splice @blocks, 7, 0, {
        full_text => "M: $mem%",
        name      => "mem",
        color     => $color,
    };

    # Output the line as JSON.
    print encode_json(\@blocks) . ",\n";
}
