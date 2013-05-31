#!/bin/bash
#
#
# By: IAN MILLIGAN, University of Waterloo (i2milligan@uwaterloo.ca)
# All code licensed under CC-BY
#
# This toolkit integrates a number of things that historians may find helpful
# when using WARC files.
#
# Will need a modern version of wget, can download source
# http://www.gnu.org/software/wget/ (will incorporate instructions in future)
#
# As it stands, we take a website, turn it into a WARC, and then generate analytics using Mathematica.
# MathKernel alias needs to be set.

# THIS SECTION TAKES A WARC FILE PASSED VIA COMMAND LINE AND USES WARC TOOLS.

WARC=$1
KWIC=$2
JUSTFILE=${WARC%?????}
OUTPUT=$JUSTFILE"-filtered.warc"

# THIS SECTION TAKES THE WARC FILE AND GENERATES A FULL TEXT INDEX
# USING A COMBINATION OF WARC TOOLS AND MANDEL WARC TOOLS. YOU WILL ALSO NEED LYNXLET TO RENDER FULL TEXT WEBPAGES.

# WARC TOOLS: http://code.hanzoarchives.com/warc-tools
# MANDEL WARC TOOLS (SOME EXTENDED FUNCTIONALITY): http://mandal.ca/web.cgi/HelpOnWarcTools
# LYNXLET: http://habilis.net/lynxlet/ 

warcfilter -T response $WARC > $OUTPUT
mkdir html
warchtmlindex.py $OUTPUT > index.html
python /users/ianmilligan1/desktop/research/warc/warc-tools-mandel/filesdump.py $OUTPUT # CHANGE PATH

# THIS FOLLOWING SECTION THEN TAKES THE FULL TEXT INDEX AND TOPIC MODELS IT. COMMENTED OUT IF USING STANFORD.
# YOU WILL NEED TO CHANGE PATH TO YOUR MALLET INSTALL.

/users/ianmilligan1/mallet-2.0.7/bin/mallet import-file --input fulltext.html --output warc.mallet --keep-sequence --remove-stopwords
/users/ianmilligan1/mallet-2.0.7/bin/mallet train-topics --input warc.mallet --num-topics 50 --output-state warc-topic-state.gz --output-topic-keys warc_keys.txt --output-doc-topics warc_composition.txt

# This first part takes the WARC-TOOLS output and formats it into the right format for StanfordHCI/Termite.
# For this format, each WARC component needs to be on one line with a file number before it.

textutil -convert txt fulltext.html # converts output file into fulltext.txt

sed  's .\{4\}  ' fulltext.txt > fulltext2.txt # eliminates starting tabs

rm fulltext.txt

cat -n fulltext2.txt | perl -pe "s/^\s*(\d+)\s+/\1\t/" > fulltext.txt # introduces line numbers

rm fulltext2.txt

sed -i.old $'s/\xE2\x80\xA8/ /g' fulltext.txt # removes weird unicode (hex 2028) line break

# Some WARC files are too big, so you may need to truncate number of lines depending on memory.
# default below takes first five files (1,5p) but replace upwards to change range.

sed -n 1,5p fulltext.txt > lines.txt 

# now run Mathematica Script

alias math="/Applications/Mathematica.app/Contents/MacOS/MathKernel"

math -script WARC-to-Analysis-Mathematica.m $KWIC