#!/bin/sh
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



# This is a (very) rough script to generate standoff config files for you.
# It does minimal error checking and is really intended to get you
# started, but it does make standoff friendlier to use on one target.

echo "Enter save name for this configuration:"
read SAVENAME
if [ -z "$SAVENAME" ]; then
	echo "Must enter a name for this configuration"
	exit
fi
mkdir "$SAVENAME"

echo "Enter target, one per line:"
read TARGET
if [ -z "$TARGET" ]; then
	echo "Must enter a target"
	rm -rf "$SAVENAME"
	exit
fi
echo "$TARGET" > "$SAVENAME"/target

echo "Enter files to upload (leave empty if you don't want to upload files):"
read FILES
echo "$FILES" > "$SAVENAME"/files

echo "Enter commands to run (leave empty if you don't want to run any commands):"
read COMMANDS
echo "$COMMANDS" > "$SAVENAME"/commands

echo "Run standoff now (y/n)?"
read ANSWER
if [ "$ANSWER" = "y" ]; then
	echo "Running standoff now..."
		if [ -z "$FILES" ]; then
		    standoff -t "$SAVENAME"/target -c "$SAVENAME"/commands
		else
		    standoff -t "$SAVENAME"/target -f "$SAVENAME"/files -c "$SAVENAME"/commands
		fi
else
	echo "Files placed in \"$SAVENAME\" directory. Exiting now"
	exit
fi
