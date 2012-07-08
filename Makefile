#Makefile for Watchdog
#Typical usage: sudo make install
#Bash scripts aren't compiled, but used for install

INSTALLDIR=/opt/wmfo/
LOCFILES=watchdog2.sh start-listenbot.sh
REMFILES=$(INSTALLDIR)watchdog2.sh $(INSTALLDIR)start-listenbot.sh

all:

install: all
	cp $(LOCFILES) $(INSTALLDIR)
	chown root $(REMFILES)
	chmod 755 $(REMFILES)

uninstall:
	rm $(REMFILES)
