# WARC-to-Specific-Counts.py

# WARC files are too big for a full frequency list to be too useful, although
# that's certainly something we could generate and dump to a text file.
# I have included that code but commented it out.

## THIS CODE GENERATES A FULL OUT FREQUENCY LIST.

# import warc

# text=open('/users/ianmilligan1/desktop/troubleshoot/lines.txt').read().lower()
# fullwordlist = warc.stripNonAlphaNum(text)
# wordlist = warc.removeStopwords(fullwordlist, warc.stopwords)
# dictionary = warc.wordListToFreqDict(wordlist)
# sorteddict = warc.sortFreqDict(dictionary)

# print sorteddict[0:500]

## THIS CODE IS MORE USEFUL AS IT LOOKS FOR SPECIFICS.
## code from http://stackoverflow.com/questions/9498665/count-occurrences-of-a-couple-of-specific-words

from collections import Counter

def count_many(needles,haystack):
    count=Counter(haystack.split())
    return{key:count[key] for key in count if key in needles}

text=open('/users/ianmilligan1/desktop/troubleshoot/lines.txt').read().lower()

print count_many(["internet", "warc", "milligan"], text)