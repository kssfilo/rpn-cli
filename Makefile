.SUFFIXES:

NAME=rpn-cli
BINNAME=recipe
VERSION=2.1.0
DESCRIPTION=Command line RPN calculator using math.js engine. example: '$$ rpn 1 2 +'
KEYWORDS=math mathjs postfix calculator calculate formula rpn reverse poplish notation HP science stdin infix 64bit bigint
NODEVER=8
LICENSE=MIT

PKGKEYWORDS=$(shell echo $$(echo $(KEYWORDS)|perl -ape '$$_=join("\",\"",@F)'))
PARTPIPETAGS="_@" "VERSION@$(VERSION)" "NAME@$(NAME)" "BINNAME@$(BINNAME)" "DESCRIPTION@$(DESCRIPTION)" 'KEYWORDS@$(PKGKEYWORDS)' "NODEVER@$(NODEVER)" "LICENSE@$(LICENSE)" 

ifdef CN
PARTPIPETAGS+= "CHECKUPDATENOTIFY"
NC=1
endif

#=

DESTDIR=dist
COFFEES=$(wildcard *.coffee)
TARGETNAMES=$(patsubst %.coffee,%.js,$(COFFEES)) 
TARGETS=$(patsubst %,$(DESTDIR)/%,$(TARGETNAMES))
DOCNAMES=LICENSE README.md package.json
DOCS=$(patsubst %,$(DESTDIR)/%,$(DOCNAMES))
ALL=$(TARGETS) $(DOCS)
SDK=node_modules/.gitignore
TOOLS=node_modules/.bin

#=

COMMANDS=build help pack test clean test-main

.PHONY:$(COMMANDS)

default:build

build:$(TARGETS)

docs:$(DOCS)

test:test.passed

test-main:$(TARGETS) test.bats
	./test.bats

pack:$(ALL) test.passed |$(DESTDIR)

clean:
	rm -r $(DESTDIR) test.passed node_modules 2>&1 ;true

help:
	@echo "Targets:$(COMMANDS)"

#=

test.passed:test-main
	touch $@

$(DESTDIR):
	mkdir -p $@

$(DESTDIR)/%:% $(TARGETS) Makefile|$(SDK) $(DESTDIR)
	cat $<|$(TOOLS)/partpipe -c $(PARTPIPETAGS)  >$@

$(DESTDIR)/%.js:%.coffee $(SDK) |$(DESTDIR)
ifndef NC
	$(TOOLS)/coffee-jshint -o node $< 
endif
	head -n1 $<|grep '^#!'|sed 's/coffee/node/'  >$@ 
	cat $<|$(TOOLS)/partpipe $(PARTPIPETAGS) |$(TOOLS)/coffee -bcs >> $@
	chmod +x $@

$(SDK):package.json
	npm install
	@touch $@

