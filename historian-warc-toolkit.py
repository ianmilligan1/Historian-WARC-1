# historian-warc-toolkit.py
# This toolkit integrates a number of things that historians may find helpful
# when using WARC files.
#
# It uses wget instead of urllib2 as WARC support is not yet incorporated.
# Will need a modern version of wget, can download source
# http://www.gnu.org/software/wget/ (will incorporate instructions in future)

import os

urltoget='http://ianmilligan.ca/'   # URL TO SCRAPE
output='im'                         # FILENAME TO GENERATE

command='wget '+urltoget+' --mirror --warc-file='+output

print command

os.system(command)
