#!/usr/bin/make -f

SRCDIR = $(shell pwd)

PREFIX = $(SRCDIR)/../usr
SBINDIR = $(PREFIX)/sbin

PROGRAMS = consoletype

all: $(PROGRAMS)

install: all
	install -m 0755 -d $(SBINDIR)
	install -m 0755 consoletype $(SBINDIR)

clean:
	rm -rf $(PROGRAMS)

consoletype:
	gcc $(CFLAGS) -o consoletype consoletype.c

# vim: set ts=4
