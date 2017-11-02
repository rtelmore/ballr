PKG_VERSION = $(shell gawk '/^Version:/{print $$2}' DESCRIPTION)
PKG_NAME    = $(shell gawk '/^Package:/{print $$2}' DESCRIPTION)

SRC    = $(wildcard src/*.cpp)
RFILES = $(wildcard R/*.R)
EXAMPLES = $(wildcard examples/*.R)
VIGNETTES = $(wildcard vignettes/*.R) 
#VIGNETTES = $(shell find . -regex "./vignettes/.*\.R[mn][dw]")
RAWDATAR  = $(wildcard data-raw/*.R)

.PHONY: all
.PRECIOUS: %.md5

all: $(PKG_NAME)_$(PKG_VERSION).tar.gz

.document.Rout: $(RFILES) $(SRC) $(EXAMPLES) $(RAWDATAR)
	if [ -d "./data-raw" ]; then $(MAKE) -C data-raw/; fi
	echo "devtools::document()" > .document.R
	R CMD BATCH --vanilla .document.R
	/bin/rm -f .document.R

.vignettes.Rout: $(VIGNETTES)
	if [ -d "./vignettes" ]; then $(MAKE) -C vignettes; fi
	echo "date()" > .vignettes.R
	R CMD BATCH --vanilla .vignettes.R
	/bin/rm -f .vignettes.R

$(PKG_NAME)_$(PKG_VERSION).tar.gz: .document.Rout .vignettes.Rout DESCRIPTION
	R CMD build --no-resave-data --md5 .

check: $(PKG_NAME)_$(PKG_VERSION).tar.gz
	R CMD check $(PKG_NAME)_$(PKG_VERSION).tar.gz

install: $(PKG_NAME)_$(PKG_VERSION).tar.gz
	R CMD INSTALL $(PKG_NAME)_$(PKG_VERSION).tar.gz

clean:
	/bin/rm -f  $(PKG_NAME)_*.tar.gz
	/bin/rm -rf $(PKG_NAME).Rcheck
	/bin/rm -f .document.Rout
	/bin/rm -f .vignettes.Rout
	/bin/rm -f inst/doc/*

