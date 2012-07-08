#Makefile for Watchdog
#Bash scripts aren't compiled, but used for install
#Typical usage: git pull
#               sudo make install

INSTALLDIR = /opt/wmfo/watchdog
OWNER = root
MOD = 755
WATCHDOG = watchdog2.sh
STARTLISTENBOT = start-listenbot.sh
LOCFILES = $(WATCHDOG) $(STARTLISTENBOT)
LIVEFILES = $(INSTALLDIR)/$($WATCHDOG) $(INSTALLDIR)/$(STARTLISTENBOT)


.PHONY all
all:
	@echo "No default action. Try 'sudo make install' to install script."

.PHONY: install
install: $(INSTALLDIR)/$(WATCHDOG) $(INSTALLDIR)/$(STARTLISTENBOT)

.PHONY: uninstall
uninstall:
	$(RM) $(LIVEFILES)

$(INSTALLDIR)/$(WATCHDOG): $(WATCHDOG)
	cp $< $@
	chown $(OWNER) $@
	chmod $(MOD) $@

$(INSTALLDIR)/$(STARTLISTENBOT): $(STARTLISTENBOT)
	cp $< $@
	chown $(OWNER) $@
	chmod $(MOD) $@
