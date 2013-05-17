# warc.py
#
# Code adopted from the _Programming Historian 2_, which I am an editor-at-large.
# Check us out! http://programminghistorian.org
#
# All code released under CC-BY license.
# Given a KWIC, return a string that is formatted for
# pretty printing.
 
def stripNonAlphaNum(text):
    import re
    return re.compile(r'\W+', re.UNICODE).split(text)

# Given a KWIC, return a string that is formatted for
# pretty printing.

def prettyPrintKWIC(kwic):
    n = len(kwic)
    keyindex = n // 2
    width = 10
 
    outstring = ' '.join(kwic[:keyindex]).rjust(width*keyindex)
    outstring += str(kwic[keyindex]).center(len(kwic[keyindex])+6)
    outstring += ' '.join(kwic[(keyindex+1):])
 
    return outstring

# Given a list of words and a number n, return a list
# of n-grams.

def getNGrams(wordlist, n):
    return [wordlist[i:i+n] for i in range(len(wordlist)-(n-1))]

# Given a list of n-grams, return a dictionary of KWICs,
# indexed by keyword.

def nGramsToKWICDict(ngrams):
    keyindex = len(ngrams[0]) // 2

    kwicdict = {}

    for k in ngrams:
      if k[keyindex] not in kwicdict:
        kwicdict[k[keyindex]] = [k]
      else:
        kwicdict[k[keyindex]].append(k)
    return kwicdict

# Given name of calling program, a url and a string to wrap,
# output string in html body with basic metadata
# and open in Firefox tab.

def wrapStringInHTML(program, url, body):
    import datetime
    from webbrowser import open_new_tab
    now = datetime.datetime.today().strftime("%Y%m%d-%H%M%S")
    filename = program + '.html'
    f = open(filename,'w')
    wrapper = """<html>
        <head>
        <title>%s output - %s</title>
        </head>
        <body><p>URL: <a href=\"%s\">%s</a></p><p>%s</p></body>
        </html>"""
    whole = wrapper % (program, now, url, url, body)
    f.write(whole)
    f.close()

    #Change the filepath variable below to match the location of your directory
    filename = 'file:///Users/ianmilligan1/Desktop/' + filename

    open_new_tab(filename)