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

my $config_file;
my $ssh;

GetOptions("config_file|f=s" => \$config_file)
	or die "Error parsing command line arguments";

my $cfg = Config::IniFiles->new(-file => "$config_file", -nomultiline => 1);

my @targets = $cfg->val('Targets', 'target');
chomp(@targets);

my @keypath = $cfg->val('Targets', 'ssh_key');
chomp(@keypath);

my @files = $cfg->val('Files', 'file');
chomp(@files);

my @commands = $cfg->val('Commands', 'command');
chomp(@commands);

foreach (@targets) {
	if (@keypath) {
		$ssh = Net::OpenSSH->new($_, key_path => @keypath);
	       	$ssh->error and warn "Couldn't connect: " . $ssh->error;
	} else {
		$ssh = Net::OpenSSH->new($_);
                $ssh->error and warn "Couldn't connect: " . $ssh->error;
	}

	if (@files) {
            foreach (@files) {
               	    $ssh->scp_put($_, $_) or die "Upload of \'$_\' failed: " . $ssh->error;
            }
	}

	if (@commands) {
            foreach (@commands) {
               	    $ssh->system({tty => 1}, $_) or die "Command \'$_\' failed: " . $ssh->error;
            }
	}
}
