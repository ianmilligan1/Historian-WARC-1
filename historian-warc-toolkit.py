# historian-warc-toolkit.py
#
# DO NOT USE THIS VERSION - IT HAS BEEN SUPERCEDED BY BASH VERSION
#
# This toolkit integrates a number of things that historians may find helpful
# when using WARC files.
#
# It uses wget instead of urllib2 as WARC support is not yet incorporated.
# Will need a modern version of wget, can download source
# http://www.gnu.org/software/wget/ (will incorporate instructions in future)
#
# For subsequent tinkering, if you already have the file, just comment out a section by placing
# an asterisk in front of it.

import os
import tarfile

# This section downloads a URL and generates a WARC file for it.

urltoget='http://ianmilligan.ca/'   # URL TO SCRAPE
output='im'                         # FILENAME TO GENERATE
output2=output+'.warc'

#command1='wget '+urltoget+' --mirror --warc-file='+output

command1='wget '+urltoget+' --warc-file='+output # for trial purposes


os.system(command1)
os.system('gunzip '+output+'.warc.gz')

# This section takes the WARC file and generates a fulltext index.

output3=output+'-filtered.warc'

command2='warcfilter -T response '+output2+' > '+output3
command3='warchtmlindex.py '+output3+' > index.html'
command4='python /users/ianmilligan1/desktop/research/warc/warc-tools-mandel/filesdump.py '+output3

os.system(command2)
os.system(command3)
os.system("mkdir html")
os.system(command4)

# This section takes the fulltext index and topic models it.

os.system('/users/ianmilligan1/mallet-2.0.7/bin/mallet --input-file fulltext.html --output warc.mallet --keep-sequence --remove-stopwords')
os.system('/users/ianmilligan1/mallet-2.0.7/bin/mallet train-topics --input warc.mallet --num-topics 50 --output-state warc-topic-state.gz --output-topic-keys warc_keys.txt --output-doc-topics warc_compostion.txt')
