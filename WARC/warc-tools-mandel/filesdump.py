#!/usr/bin/env python
"""warcdump - dump warcs in a slightly more humane format"""

import os
import sys

import zipfile
import os.path

from optparse import OptionParser

from warctools import ArchiveRecord, WarcRecord

parser = OptionParser(usage="%prog [options] warc warc warc")

parser.add_option("-l", "--limit", dest="limit")
parser.add_option("-I", "--input", dest="input_format")
parser.add_option("-L", "--log-level", dest="log_level")

parser.set_defaults(output_directory=None, limit=None, log_level="info")

def main(argv):
    (options, input_files) = parser.parse_args(args=argv[1:])

    out = sys.stdout
    

    if len(input_files) < 1:
        dump_archive(WarcRecord.open_archive(file_handle=sys.stdin, gzip=None), name="-",offsets=False)
        
    else:
        for name in input_files:
            fh = ArchiveRecord.open_archive(name, gzip="auto")
            dump_archive(fh,name)
            fh.close()

    

    tf = zipfile.ZipFile("dump.zip", "w")
    for dirname, subdirs, files in os.walk("html"):
        for filename in files:
           tf.write(os.path.join(dirname, filename))
    tf.write("fulltext.html")
    tf.write("index.html")
    tf.close()

        

    return 0

def dump_archive(fh, name, offsets=True):
    t = open("fulltext.html", 'w')
    t.write("<html><ol>")
    txt = ''
    for (offset, record, errors) in fh.read_records(limit=None, offsets=offsets):
        if record:
            txt = record.filedump(content=True)
            t.write(txt)
    t.write("</ol></html>")
    t.close()

if __name__ == '__main__':
    sys.exit(main(sys.argv))



