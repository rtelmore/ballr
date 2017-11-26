PKG_VERSION = $(shell gawk '/^Version:/{print $$2}' DESCRIPTION)
PKG_NAME    = $(shell gawk '/^Package:/{print $$2}' DESCRIPTION)

SRC    = $(wildcard src/*.cpp)
RFILES = $(wildcard R/*.R)
EXAMPLES = $(wildcard examples/*.R)
VIGNETTES = $(wildcard vignettes/*.R) 
#VIGNETTES = $(shell find . -regex "./vignettes/.*\.R[mn][dw]")
RAWDATAR  = $(wildcard data-raw/*.R)

.PHONY: all help
.PRECIOUS: %.md5
	
all: $(PKG_NAME)_$(PKG_VERSION).tar.gz  ## Build the R package.  

help: ## Show this help list
	@echo "--------------------\nRecipes:\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo "\n\n--------------------\nCommand-line Options\n"
	@echo "build-options\tOptions passed to R CMD build (see R CMD build --help).\n\t\tThe default options in this makefile are --no-resave-data --md5.\n\t\tTo skip building the vigettes, for example, use\n\n\t\t\tmake all build-options='--no-build-vignettes'"
	@echo "\ncheck-options\tOptions passed to R CMD check (see R CMD check --help).\n"

.document.Rout: $(RFILES) $(SRC) $(EXAMPLES) $(RAWDATAR)  ## Build data sets and man files
	if [ -e "./data-raw/makefile" ]; then $(MAKE) -C data-raw/; fi
	echo "devtools::document()" > .document.R
	R CMD BATCH --vanilla .document.R
	/bin/rm -f .document.R

.vignettes.Rout: $(VIGNETTES) ## build the vignettes
	if [ -e "./vignettes/makefile" ]; then $(MAKE) -C vignettes; fi
	echo "date()" > .vignettes.R
	R CMD BATCH --vanilla .vignettes.R
	/bin/rm -f .vignettes.R

$(PKG_NAME)_$(PKG_VERSION).tar.gz: .document.Rout .vignettes.Rout DESCRIPTION
	R CMD build --no-resave-data --md5 $(build-options) .

check: $(PKG_NAME)_$(PKG_VERSION).tar.gz  ## Check the package
	R CMD check $(check-options) $(PKG_NAME)_$(PKG_VERSION).tar.gz

install: $(PKG_NAME)_$(PKG_VERSION).tar.gz ## Install the package
	R CMD INSTALL $(install-options) $(PKG_NAME)_$(PKG_VERSION).tar.gz

clean:  ## clean up the working directory
	/bin/rm -f  $(PKG_NAME)_*.tar.gz
	/bin/rm -rf $(PKG_NAME).Rcheck
	/bin/rm -f .document.Rout
	/bin/rm -f .vignettes.Rout
	/bin/rm -f inst/doc/*

