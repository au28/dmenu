# dmenu - dynamic menu
# See LICENSE file for copyright and license details.

include config.mk

SRC = drw.c dmenu.c stest.c util.c
OBJ = $(SRC:.c=.o)

all: options dmenu stest

options:
	@echo dmenu build options:
	@echo "CFLAGS   = $(CFLAGS)"
	@echo "LDFLAGS  = $(LDFLAGS)"
	@echo "CC       = $(CC)"

.c.o:
	$(CC) -c $(CFLAGS) $<

config.h:
	cp config.def.h $@

$(OBJ): arg.h config.h config.mk drw.h

dmenu: dmenu.o drw.o util.o
	$(CC) -o $@ dmenu.o drw.o util.o $(LDFLAGS)

stest: stest.o
	$(CC) -o $@ stest.o $(LDFLAGS)

clean:
	rm -f dmenu stest $(OBJ) dmenu-$(VERSION).tar.gz

dist: clean
	mkdir -p dmenu-$(VERSION)
	cp LICENSE Makefile README arg.h config.def.h config.mk dmenu.1\
		drw.h util.h stest.1 $(SRC)\
		dmenu-$(VERSION)
	tar -cf dmenu-$(VERSION).tar dmenu-$(VERSION)
	gzip dmenu-$(VERSION).tar
	rm -rf dmenu-$(VERSION)

install: all
	mkdir -p $(PREFIX)/bin
	cp -f dmenu stest $(PREFIX)/bin
	chmod 755 $(PREFIX)/bin/dmenu
	chmod 755 $(PREFIX)/bin/stest
	mkdir -p $(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < dmenu.1 > $(MANPREFIX)/man1/dmenu.1
	sed "s/VERSION/$(VERSION)/g" < stest.1 > $(MANPREFIX)/man1/stest.1
	chmod 644 $(MANPREFIX)/man1/dmenu.1
	chmod 644 $(MANPREFIX)/man1/stest.1

uninstall:
	rm -f $(PREFIX)/bin/dmenu\
		$(PREFIX)/bin/stest\
		$(MANPREFIX)/man1/dmenu.1\
		$(MANPREFIX)/man1/stest.1

.PHONY: all options clean dist install uninstall
