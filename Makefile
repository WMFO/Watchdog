#Makefile for Watchdog
#Bash scripts aren't compiled, but used for install
#Suggested usage: git pull
#                 sudo make install

INSTALLDIR = /opt/wmfo/watchdog
OWNER = root
MOD = 755
FILES = watchdog2.sh start-listenbot.sh

.PHONY: all install uninstall

all:
	@echo "make: nothing to build for bash scripts"
	@echo "make: suggested usage: sudo make install"

install: $(addprefix $(INSTALLDIR)/, $(FILES))

$(INSTALLDIR)/%.sh: %.sh
	@cp $< $@
	@chown $(OWNER) $@
	@chmod $(MOD) $@

uninstall: 
	for file in $(FILES); do \
	$(RM) $(INSTALLDIR)/$$file ; \
	done

