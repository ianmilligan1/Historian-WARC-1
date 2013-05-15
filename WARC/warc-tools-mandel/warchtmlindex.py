#!/usr/bin/env python
"""warcindex - dump warc index"""

import os
import sys

import sys
import os.path

from optparse import OptionParser
import textwrap
from warctools import ArchiveRecord

parser = OptionParser(usage="%prog [options] warc warc warc")

parser.add_option("-l", "--limit", dest="limit")
parser.add_option("-O", "--output-format", dest="output_format", help="output format (ignored)")
parser.add_option("-o", "--output", dest="output_format", help="output file (ignored)")

parser.add_option("-L", "--log-level", dest="log_level")

parser.set_defaults(output=None, limit=None, log_level="info")

def main(argv):
    (options, input_files) = parser.parse_args(args=argv[1:])

    out = sys.stdout
    if len(input_files) < 1:
        parser.error("no imput warc file(s)")
    print "<html>"
    print '<head><style type="text/css" media="all">table{width:100%;border-collapse:collapse;}td,th{border:solid 1px black;padding:0.1em;word-wrap:break-word}</style></head>'
    print "<body>"
    for name in input_files:
        fh = ArchiveRecord.open_archive(name, gzip="auto")
        print "<h1>"+name+"</h1>"
        print '<table>'    
        print '<tr><th>warc-subject-uri</th><th>content-type</th><th>content-length</th></tr>'

        for (offset, record, errors) in fh.read_records(limit=None):
            if record:
                fname = record.id
                fname = fname.strip('<>')
                fnameu = fname[9:]+".html"

                urlu = textwrap.fill(record.url, 60)

                print("<tr><td><a href=\"html/%s\" id=\"%s\">%s</a></td><td>%s</td><td>%s</td></tr>" % (fnameu, record.url, urlu, record.content_type, record.content_length))
            elif errors:
                pass
                # ignore
            else:
                pass
                # no errors at tail




        fh.close()

        print "</table>"
        print "</body>"
        print "</html>"

    return 0

if __name__ == '__main__':
    sys.exit(main(sys.argv))



