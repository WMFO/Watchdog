#Makefile for Watchdog
#Bash scripts aren't compiled, but used for install
#Suggested usage: git pull
#                 sudo make install

INSTALLDIR = /opt/wmfo/watchdog
OWNER = root
MOD = 755
WATCHDOG = watchdog2.sh
STARTLISTENBOT = start-listenbot.sh
FILES = $(WATCHDOG) $(STARTLISTENBOT) 

.PHONY all
all:
	@echo "make: nothing to build for bash scripts"
	@echo "make: suggested usage: sudo make install"

.PHONY: install
install: $(INSTALLDIR)/$(WATCHDOG) $(INSTALLDIR)/$(STARTLISTENBOT)

$(INSTALLDIR)/$(WATCHDOG): $(WATCHDOG)
	cp $< $@
	chown $(OWNER) $@
	chmod $(MOD) $@

$(INSTALLDIR)/$(STARTLISTENBOT): $(STARTLISTENBOT)
	cp $< $@
	chown $(OWNER) $@
	chmod $(MOD) $@

.PHONY uninstall
uninstall: 
	for file in $(FILES); do \
	$(RM) $(INSTALLDIR)/$$file ; \
	done

