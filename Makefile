#Makefile for Watchdog
#Bash scripts aren't compiled, but used for install
#Suggested usage: git pull
#                 sudo make install

INSTALLDIR = /opt/wmfo/watchdog
FILES = watchdog2.sh start-listenbot.sh

.PHONY all
all:
	@echo "make: nothing to build for bash scripts"
	@echo "make: suggested usage: sudo make install"

.PHONY install
install: 
	for file in $(FILES) ; do \
	cp $$file $(INSTALLDIR)/$$file ; \
	chown root $(INSTALLDIR)/$$file ; \
	chmod 755 $(INSTALLDIR)/$$file ; \
	done

.PHONY uninstall
uninstall: 
	for file in $(FILES) ; do \
	rm $(INSTALLDIR)/$$file ; \
	done

