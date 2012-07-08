#Makefile for Watchdog
#Bash scripts aren't compiled, but used for install
#Typical usage: git pull
#				sudo make install

INSTALLDIR=/opt/wmfo/watchdog/
LOCFILES=watchdog2.sh start-listenbot.sh
REMFILES=$(INSTALLDIR)watchdog2.sh $(INSTALLDIR)start-listenbot.sh

all:

install: all
	cp $(LOCFILES) $(INSTALLDIR)
	chown root $(REMFILES)
	chmod 755 $(REMFILES)

uninstall:
	rm $(REMFILES)
