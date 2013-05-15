#!/bin/bash
# WARC-Tools to StanfordHCI/Termite
# Ian Milligan, University of Waterloo (i2milligan@uwaterloo.ca)

# run in path of file
# this is messy, creating several files (allowed me to find issues)

# This first part takes the WARC-TOOLS output and formats it into the right format for StanfordHCI/Termite.
# For this format, each WARC component needs to be on one line with a file number before it.

textutil -convert txt fulltext.html # converts output file into fulltext.txt

sed  's .\{4\}  ' fulltext.txt > fulltext2.txt # eliminates starting tabs

cat -n fulltext2.txt | perl -pe "s/^\s*(\d+)\s+/\1\t/" > fulltext3.txt # introduces line numbers

sed -i.old $'s/\xE2\x80\xA8/ /g' fulltext3.txt # removes weird unicode (hex 2028) line break

# Some WARC files are too big, so you may need to truncate number of lines depending on memory.
# default below takes first five files (1,5p) but replace upwards to change range.

sed -n 1,5p fulltext3.txt > lines.txt 

## This file is now ready to be run with StanfordHCI/termite [https://github.com/StanfordHCI/termite]
## For StanfordHCI, create a config file pointing at output2.txt and execute
