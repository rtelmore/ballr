SOURCES = $(wildcard *.R)
TARGETS = $(addsuffix .Rmd, $(basename $(SOURCES)))

all: $(TARGETS)

%.Rmd: %.R
	R --vanilla -e "knitr::spin(hair = '$<', knit = FALSE)"
