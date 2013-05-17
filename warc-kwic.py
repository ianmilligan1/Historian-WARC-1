# warc-kwic.py

# If you need to see if a WARC might be relevant for your research,
# this program provides full keyword in context.
#
# OUTSTANDING ISSUES:
# - URL needs to be fixed so that it reads from the WARC file, for final output
# - DUPLICATION - that's an effect of the WARC-Tools output, but it can be
#                 annoying. However, some users might want this?
# - SPEED - not too fast, but chunked through pretty big file decently.
#
# Code adopted from the _Programming Historian 2_, which I am an editor-at-large.
# Check us out! http://programminghistorian.org
#
# All code released under CC-BY license.

import warc

url='http://ianmilligan.ca/' # need to grab from WARC file
n=7

text=open('/users/ianmilligan1/desktop/troubleshoot/fulltext.txt').read()

# need to figure out how to push this from a bash script?!

fullwordlist = ('# ' * (n//2)).split()
fullwordlist += warc.stripNonAlphaNum(text)
fullwordlist += ('# ' * (n//2)).split()
ngrams = warc.getNGrams(fullwordlist, n)
worddict = warc.nGramsToKWICDict(ngrams)

# output KWIC and wrap with html
target = 'internet'
outstr = '<pre>'
if worddict.has_key(target):
    for k in worddict[target]:
        outstr += warc.prettyPrintKWIC(k)
        outstr += '<br />'
else:
    outstr += 'Keyword not found in source'
outstr += '</pre>'
warc.wrapStringInHTML('html-to-kwic', url, outstr)

