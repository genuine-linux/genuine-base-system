# genuine-base-system Makefile

INSTALL_DIR    = install -m 0755 -d

all:

install:
	$(INSTALL_DIR) $(DESTDIR)/etc
	cp -pPR etc/* $(DESTDIR)/etc/
	$(INSTALL_DIR) $(DESTDIR)/usr
	cp -pPR usr/* $(DESTDIR)/usr/
	$(INSTALL_DIR) $(DESTDIR)/sbin
	cp -pPR sbin/* $(DESTDIR)/sbin/
	$(INSTALL_DIR) $(DESTDIR)/bin
	cp -pPR bin/* $(DESTDIR)/bin/

.PHONY: all install

