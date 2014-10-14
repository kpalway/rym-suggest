rym-suggest
===========

- [About](#about)
- [rym-cmd](#rym-cmd)

#About
------

rym-suggest works with user ratings data downloaded from [RateYourMusic](http://rateyourmusic.com) to provide listening suggestions from a user's ratings library. This is useful for indecisive people with large music libraries, or for generating automatic recommendations from a friend's music library (if they send you their exported data).

#rym-cmd
--------

The file `rym-cmd.rkt` provides a command line interface for rym-suggest. It takes one parameter, the location of a file containing exported user data.

Options:
- `-n [number]` - Specify the number of results to return. Default is 10.
- `-y [year]` - Specify a specific year to return results from. If unspecified, results are taken from all years.

Run with `racket rym-cmd.rkt user-export-data.txt`, for example.
