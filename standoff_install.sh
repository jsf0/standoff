#!/bin/sh

install -m 755 -d /usr/local/bin
install -m 755 standoff /usr/local/bin
install -m 755 standoff_generator.sh /usr/local/bin
install -m 755 -d /usr/local/man/man1
install -m 644 standoff.1 /usr/local/man/man1