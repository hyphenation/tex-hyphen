[![Build Status](https://api.travis-ci.com/hyphenation/tex-hyphen.svg?branch=master)](https://api.travis-ci.com/hyphenation/tex-hyphen.svg)

This is the central repository for all hyphenation patterns (that we know of).
These patterns are encoded in UTF-8, but can also be used with 8-bit TeX
engines such as pdfTeX with the help of mechanisms provided with the package.
It is meant to be a low-level package and is integrated with all major TeX
distributions (TeX Live, MiKTeX, W32TeX); most TeX users should thus not
concern themselves with this package, unless of course they’re working on the
hyphenation patterns themselves.

We upload the package to CTAN regularly and use git branches to identify versions;
a CTAN upload has a version date in the form `yyyy-mm-dd`, corresponding to branch
`CTAN-yyyy.mm.dd` in this git repository. Because the package contains
contributions from many different sources that are not updated at the same
time, we felt this was this best choice for version identifiers.

If you are an author of hyphenation patterns and want to add or update them,
please contact the maintainers through the mailing list: tex-hyphen@tug.org
You can also visit the [TeX hyphenation page](http://www.hyphenation.org/tex) for more
information and technical details.

# Licence

Unless otherwise mentioned, all files are placed under the [MIT licence][https://opensource.org/licenses/mit].  There are, however, a number of exceptions that all occur in the “core” `hyph-*.tex` files and their derivatives, meaning that it cannot be assumed that the actual licences (and there are many of them) are suitable for any particular project.

# Running
`bundle` (or `bundle install`)
`bundle exec rake` runs the default task in the Rakefile.
