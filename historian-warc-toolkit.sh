#!/bin/bash
#
# By: IAN MILLIGAN, University of Waterloo (i2milligan@uwaterloo.ca)
# All code licensed under CC-BY
#
# This toolkit integrates a number of things that historians may find helpful
# when using WARC files.
#
# It is an implementation of historian-warc-toolkit.py in bash.
# Will need a modern version of wget, can download source
# http://www.gnu.org/software/wget/ (will incorporate instructions in future)

# THIS SECTION DOWNLOADS A URL AND GENERATES A WARC FILE FOR IT.

URLTOGET="http://ianmilligan.ca/" # CHANGE THIS DEPENDING ON WHAT YOU WANT
OUTPUT="im"
OUTPUT2=$OUTPUT".warc"
OUTPUT3=$OUTPUT"-filtered.warc"

# wget $URLTOGET --mirror --warc-file=im"

wget $URLTOGET --warc-file=im # USE FIRST COMMAND IF YOU WANT A FULL TEXT OF THE ENTIRE WEBSITE, THIS VERSION IS FOR DEBUGGING, grabs only index

gunzip $OUTPUT".warc.gz"

# THIS SECTION TAKES THE WARC FILE AND GENERATES A FULL TEXT INDEX
# USING A COMBINATION OF WARC TOOLS AND MANDEL WARC TOOLS. YOU WILL ALSO NEED LYNXLET TO RENDER FULL TEXT WEBPAGES.

# WARC TOOLS: http://code.hanzoarchives.com/warc-tools
# MANDEL WARC TOOLS (SOME EXTENDED FUNCTIONALITY): http://mandal.ca/web.cgi/HelpOnWarcTools
# LYNXLET: http://habilis.net/lynxlet/ 

warcfilter -T response $OUTPUT2 > $OUTPUT3
mkdir html
warchtmlindex.py $OUTPUT3 > index.html
python /users/ianmilligan1/desktop/research/warc/warc-tools-mandel/filesdump.py $OUTPUT3 # CHANGE PATH

head -n 5 fulltext.html >> 'condensed.html'
## CREATES A TRUNCATED FULL TEXT FILE WITH THE FIRST 'n' PAGES
## by default, set at 5, but could be tinkered with.
## this file is easier to work w/ for text counting, etc.

# THIS FOLLOWING SECTION THEN TAKES THE FULL TEXT INDEX AND TOPIC MODELS IT.
# YOU WILL NEED TO CHANGE PATH TO YOUR MALLET INSTALL.

/users/ianmilligan1/mallet-2.0.7/bin/mallet import-file --input fulltext.html --output warc.mallet --keep-sequence --remove-stopwords
/users/ianmilligan1/mallet-2.0.7/bin/mallet train-topics --input warc.mallet --num-topics 50 --output-state warc-topic-state.gz --output-topic-keys warc_keys.txt --output-doc-topics warc_compostion.txt

