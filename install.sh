#!/bin/sh

install -m 755 -d /usr/local/bin
install -m 755 standoff.pl /usr/local/bin/standoff
install -m 755 -d /usr/local/man/man1
install -m 644 standoff.1 /usr/local/man/man1
