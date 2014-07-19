CABAL = /usr/bin/env cabal
PROJ = "lxc-bind"

default: build run

configure:
	$(CABAL) configure

clean:
	$(CABAL) clean

build: clean configure
	$(CABAL) build

run:
	@./dist/build/$(PROJ)/$(PROJ)
