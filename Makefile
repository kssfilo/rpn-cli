.SUFFIXES:

VERSION=1.1.3

#=

COMMANDS=help pack test clean

#=

DESTDIR=dist
COFFEES=$(wildcard *.coffee)
TARGETNAMES=package.json LICENSE $(patsubst %.coffee,%.js,$(COFFEES)) 
TARGETS=$(patsubst %,$(DESTDIR)/%,$(TARGETNAMES))
ALL=$(TARGETS) $(DESTDIR)/README.md
SDK=node_modules/.gitignore
TOOLS=node_modules/.bin

#=

.PHONY:$(COMMANDS)

pack:$(ALL)|$(DESTDIR)

test:$(TARGETS) test.bats
	chmod +x dist/cli.js
	./test.bats

clean:
	-rm -r $(DESTDIR) node_modules

help:
	@echo "Targets:$(COMMANDS)"

#=

$(DESTDIR):
	mkdir -p $@

$(DESTDIR)/README.md:README.md $(TARGETS)
	cp README.md $@
	vim $@ -c '/@SEE_NPM_README@/||delete||-1||read!./cli.coffee -h' -c '%s/cli\.coffee/rpn/g||x!'

$(DESTDIR)/package.json:package.json|$(DESTDIR)
	cp $< $@
	vim $@ -c '%s/__VERSION__/version/|%s/@VERSION@/$(VERSION)/g||x!'

$(DESTDIR)/%.js:%.coffee $(SDK)|$(DESTDIR)
ifndef NC
	$(TOOLS)/coffee-jshint -o node $< 
endif
	head -n1 $<|grep '^#!'|sed 's/coffee/node/'  >$@ 
	cat $<|$(TOOLS)/coffee -bcs >> $@

$(DESTDIR)/%:%|$(DESTDIR)
	cp $< $@

$(SDK):package.json
	npm install
	@touch $@
