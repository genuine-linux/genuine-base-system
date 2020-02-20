# genuine-base-system Makefile
# Copyright 2006-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
#
# We've moved the installation logic from Gentoo ebuild into a generic
# Makefile so that the ebuild is much smaller and more simple.
# It also has the added bonus of being easier to install on systems
# without an ebuild style package manager.

PKG_VERSION = G20.02.02
PKG = genuine-base-system-$(PKG_VERSION)
DISTFILE = $(PKG).tar.bz2

CHANGELOG_LIMIT = --after="1 year ago"

INSTALL_DIR    = install -m 0755 -d
INSTALL_EXE    = install -m 0755
INSTALL_FILE   = install -m 0644
INSTALL_SECURE = install -m 0600

OS=$(shell uname -s)

KEEP_DIRS = /dev \
	/run \
	/sys \
	/usr/src \
	/boot \
	/etc/profile.d \
	/home \
	/media \
	/mnt \
	/proc \
	/opt \
	/root \
	/usr/local/bin \
	/usr/local/sbin \
	/var/cache \
	/var/empty \
	/var/lib \
	/var/log \
	/var/spool

all:

changelog:
	git log ${CHANGELOG_LIMIT} --format=full > ChangeLog

clean:

install:
	$(INSTALL_DIR) $(DESTDIR)/etc
	cp -pPR etc/* $(DESTDIR)/etc/
	$(INSTALL_DIR) $(DESTDIR)/usr
	cp -pPR usr/* $(DESTDIR)/usr/
	$(INSTALL_DIR) $(DESTDIR)/sbin
	cp -pPR sbin/* $(DESTDIR)/sbin/
	$(INSTALL_DIR) $(DESTDIR)/bin
	cp -pPR bin/* $(DESTDIR)/bin/

layout-dirs:
	# Create base filesytem layout
	for x in $(KEEP_DIRS) ; do \
		test -e $(DESTDIR)$$x/.keep && continue ; \
		$(INSTALL_DIR) $(DESTDIR)$$x || exit $$? ; \
		touch $(DESTDIR)$$x/.keep || echo "ignoring touch failure; mounted fs?" ; \
	done

layout: layout-dirs
	ln -snf /proc/self/mounts $(DESTDIR)/etc/mtab
	ln -snf /run $(DESTDIR)/var/run
	ln -snf /run/lock $(DESTDIR)/var/lock
	# Special dirs
	install -m 0700 -d $(DESTDIR)/root
	touch $(DESTDIR)/root/.keep
	install -m 1777 -d $(DESTDIR)/var/tmp
	touch $(DESTDIR)/var/tmp/.keep
	install -m 1777 -d $(DESTDIR)/tmp
	touch $(DESTDIR)/tmp/.keep
	# FHS compatibility symlinks stuff
	ln -snf /var/tmp $(DESTDIR)/usr/tmp

live:
	rm -rf /tmp/$(PKG)
	cp -r . /tmp/$(PKG)
	tar jcf /tmp/$(PKG).tar.bz2 -C /tmp $(PKG) --exclude=.git
	rm -rf /tmp/$(PKG)
	ls -l /tmp/$(PKG).tar.bz2

release:
	git show-ref -q --tags $(PKG)
	git archive --prefix=$(PKG)/ $(PKG) | bzip2 > $(DISTFILE)
	ls -l $(DISTFILE)

snapshot:
	git show-ref -q $(GITREF)
	git archive --prefix=$(PKG)/ $(GITREF) | bzip2 > $(PKG)-$(GITREF).tar.bz2
	ls -l $(PKG)-$(GITREF).tar.bz2

.PHONY: all changelog clean install layout  live release snapshot

# vim: set ts=4 :
