## Test environments
* local OS X install, R 3.4.2
* ubuntu (on travis-ci), R 3.4.2

## R CMD check results
There were no ERRORs or WARNINGs.

There were 2 NOTEs:

  * checking for hidden files and directories ... NOTE
Found the following hidden files and directories:
  .document.R
These were most likely included in error. See section ‘Package
structure’ in the ‘Writing R Extensions’ manual.

  * checking for unstated dependencies in vignettes ... NOTE
'::' or ':::' import not declared from: ‘devtools’
'library' or 'require' call not declared from: ‘devtools’

