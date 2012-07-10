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

.PHONY: all install uninstall

all:
	@echo "make: nothing to build for bash scripts"
	@echo "make: suggested usage: sudo make install"

install: $(INSTALLDIR)/$(WATCHDOG) $(INSTALLDIR)/$(STARTLISTENBOT)

$(INSTALLDIR)/%.sh: %.sh
	@cp $< $@
	@chown $(OWNER) $@
	@chmod $(MOD) $@

uninstall: 
	for file in $(FILES); do \
	$(RM) $(INSTALLDIR)/$$file ; \
	done

