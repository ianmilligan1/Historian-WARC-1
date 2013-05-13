#!/bin/bash
#
# This toolkit integrates a number of things that historians may find helpful
# when using WARC files.
#
# It is an implementation of historian-warc-toolkit.py in bash.
# Will need a modern version of wget, can download source
# http://www.gnu.org/software/wget/ (will incorporate instructions in future)

# THIS SECTION DOWNLOADS A URL AND GENERATES A WARC FILE FOR IT.

URLTOGET="http://ianmilligan.ca/"
OUTPUT="im"
OUTPUT2=$OUTPUT".warc"
OUTPUT3=$OUTPUT"-filtered.warc"

COMMAND1="wget "$URLTOGET" --mirror --warc-file="$OUTPUT2
$COMMAND1

gunzip $OUTPUT".warc.gz"

# THIS SECTION TAKES THE WARC FILE AND GENERATES A FULL TEXT INDEX
# USING A COMBINATION OF WARC TOOLS AND MANDEL WARC TOOLS.

warcfilter -T response $OUTPUT2 > $OUTPUT3
mkdir html
warchtmlindex.py $OUTPUT3 > index.html
python /users/ianmilligan1/desktop/research/warc/warc-tools-mandel/filesdump.py $OUTPUT3

# THIS FOLLOWING SECTION THEN TAKES THE FULL TEXT INDEX AND TOPIC MODELS IT.

/users/ianmilligan1/mallet-2.0.7/bin/mallet import-file --input fulltext.html --output warc.mallet --keep-sequence --remove-stopwords
/users/ianmilligan1/mallet-2.0.7/bin/mallet train-topics --input warc.mallet --num-topics 50 --output-state warc-topic-state.gz --output-topic-keys warc_keys.txt --output-doc-topics warc_compostion.txt