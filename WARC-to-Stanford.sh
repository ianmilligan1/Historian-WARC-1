# WARC-Tools to StanfordHCI/Termite
# Ian Milligan, University of Waterloo (i2milligan@uwaterloo.ca)

# run in path of file
# this is messy, creating several files (allowed me to find issues)
# 
# To use this, run the previous file in this repository and then run this.

## This first part takes the WARC-TOOLS output and puts it into a format happy for Stanford-Termite.
## IMPORTANT NOTE: SO FAR, ONLY WORKS ON WARC FILES WITH ONE FILE. BUT IT IS CLOSE TO BEING ABLE TO HANDLE
## MULTIPLE FILES.

textutil -convert txt fulltext.html # converts output file into fulltext.txt

#sed 's/[^     ]*      \(.*\)/\1/' fulltext.txt > fulltext1.txt # sed accepts real tab space, copy and paste does not work
#sed 's/[^     ]*      \(.*\)/\1/' fulltext1.txt > fulltext2.txt # ibid

sed  's .\{4\}  ' fulltext.txt > fulltext2.txt #  eliminates starting tabs

echo "1\t" | cat - fulltext2.txt > /tmp/out && mv /tmp/out output.txt # append the file number to front

tr -d '\r\n' <output.txt > output2.txt # eliminate line breaks

sed -i.old $'s/\xE2\x80\xA8/ /g' output2.txt # eliminates weird unicode (hex 2028) line break

## This file is now ready to be run with StanfordHCI/termite [https://github.com/StanfordHCI/termite]
## For StanfordHCI, create a config file pointing at output2.txt and execute
