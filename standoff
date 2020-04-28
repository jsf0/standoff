#!/usr/bin/env perl
# Copyright (c) 2020 Joseph Fierro <joseph.fierro@runbox.com>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

use strict;
use warnings;

use Getopt::Long;
use Net::OpenSSH;
use Config::IniFiles;

my @payload_confs;
my $ssh;
my $pull_mode = 0;

GetOptions(
    "payload_conf|f=s" => \@payload_confs,
    "p"                => \$pull_mode
) or die "Error parsing command line arguments";

if ( !@payload_confs ) {
    die "Error: No payload configuration file specified";
}

foreach my $payload (@payload_confs) {

    my $cfg = Config::IniFiles->new( -file => "$payload", -nomultiline => 1 );

    my $target = $cfg->val( 'Target', 'target' );
    if ( !$target ) {
        die "Error: No target specified in $payload";
    }
    else {
        chomp($target);
    }

    my @files = $cfg->val( 'Files', 'file' );
    if (@files) {
        chomp(@files);
    }

    my @commands = $cfg->val( 'Commands', 'command' );
    if (@commands) {
        chomp(@commands);
    }

    my $ssh_key = $cfg->val( 'Target', 'ssh_key' );
    if ($ssh_key) {
        chomp($ssh_key);
        $ssh = Net::OpenSSH->new( $target, key_path => $ssh_key );
        $ssh->error and warn "Couldn't connect: " . $ssh->error;
    }
    else {
        $ssh = Net::OpenSSH->new($target);
        $ssh->error and warn "Couldn't connect: " . $ssh->error;
    }

    if (@files) {
        foreach (@files) {
            if ($pull_mode) {
                $ssh->scp_get( $_, $_ )
                  or die "Download of \'$_\' failed: " . $ssh->error;
            }
            else {
                $ssh->scp_put( $_, $_ )
                  or die "Upload of \'$_\' failed: " . $ssh->error;
            }
        }
    }

    if (@commands) {
        foreach (@commands) {
            if ($pull_mode) {
                system($_ ) == 0
                  or die "Command \'$_\' failed: $?";
            }
            else {
                $ssh->system( { tty => 1 }, $_ )
                  or die "Command \'$_\' failed: " . $ssh->error;
            }
        }
    }
}
