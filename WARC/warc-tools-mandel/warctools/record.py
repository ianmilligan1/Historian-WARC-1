"""a skeleton class for archive records"""

from gzip import GzipFile

import re
from urlparse import urlparse

from warctools.stream import open_record_stream
#from warctools.html2text import html2text

# EDT
from subprocess import Popen, PIPE, STDOUT

strip = re.compile(r'[^\w\t \|\\\/]')

def add_headers(**kwargs):
    """a useful helper for defining header names in record formats"""
    def _add_headers(cls):
        for k,v in kwargs.iteritems():
            setattr(cls,k,v)
        cls._HEADERS = kwargs.keys()
        return cls
    return _add_headers

class ArchiveParser(object):
    """ methods parse, and trim """
    pass 


@add_headers(DATE='Date', CONTENT_TYPE='Type', CONTENT_LENGTH='Length', TYPE='Type',URL='Url')
class ArchiveRecord(object):
    """An archive record has some headers, maybe some content and
    a list of errors encountered. record.headers is a list of tuples (name,
    value). errors is a list, and content is a tuple of (type, data)"""
    def __init__(self,  headers=None, content=None, errors=None):
        self.headers = headers if headers else []
        self.content = content if content else (None, "")
        self.errors = errors if errors else []

    HEADERS=staticmethod(add_headers)

    @property
    def date(self):
        return self.get_header(self.DATE)

    def error(self, *args):
        self.errors.append(args)
        
    @property
    def type(self):
        return self.get_header(self.TYPE)

    @property
    def content_type(self):
        return self.content[0]

    @property
    def content_length(self):
        return len(self.content[1])

    @property
    def url(self):
        return self.get_header(self.URL)

    def get_header(self, name):
        for k,v in self.headers:
            if name == k:

                return v



    def dump(self, content=True):

        print 'Headers:'
        for (h,v) in self.headers:
            print '\t%s:%s'%(h,v)
        if content and self.content:
            print 'Content Headers:'
            content_type, content_body = self.content
            print '\t',self.CONTENT_TYPE,':',content_type
            print '\t',self.CONTENT_LENGTH,':',len(content_body)
            print 'Content:'
            ln = min(1024, len(content_body))
            # EDT
            textcontent = re.search("Content-Type: text/", content_body)
            if textcontent:
                 # Use lynx to format text content. Numbered links are disabled since they interfere with grep.
                 p = Popen(['lynx', '-dump', '-nolist', '-stdin', '-width=1024'], stdout=PIPE, stdin=PIPE, stderr=STDOUT)
                 lynx_stdout = p.communicate(input=content_body)[0]
                 print(lynx_stdout)

#            print '\t', strip.sub(lambda x:'\\x%00X'%ord(x.group()),content_body[:ln])
#            print '\t...'
            else:
                 print "[BINARY CONTENT NOT SHOWN]"
            print 
            print
        else:
            print 'Content: none'
            print
            print
#        if self.errors:
#            print 'Errors:'
#            for e in self.errors:
#                print '\t', e

#### START FILE DUMP


    def filedump(self, content=True):
      txt = ''
      if content and self.content:
        fname = self.get_header("WARC-Record-ID")
        fname = fname.strip('<>')
        fname = fname[9:]

        workfile = "html/"+fname+".html"
#        indexfile = fname+".txt"
        print workfile
        
        # For converting "file" (relative) urls created by lynx to absolute ones
        domain = self.get_header("WARC-Target-URI")
        pdomain = urlparse(domain)
        ud = pdomain[0]+"://"+pdomain[1]
        
        content_type, content_body = self.content
        
        # Open two files. The html is for viewing, the txt file is for full-text searching (grep)
        f = open(workfile, 'w')
#        t = open(indexfile, 'w')
        f.write("<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"></head><body><pre style=\"white-space:pre-wrap\">")
        f.write('Headers:')
        for (h,v) in self.headers:
            f.write('\n\t%s:%s'%(h,v))
        f.write('<hr>')
        textcontent = re.search("Content-Type: text/", content_body)
        if textcontent:
            # Use lynx to format text content. Numbered links are disabled since they interfere with grep.
            p = Popen(['lynx', '-dump', '-stdin', '-nomargins', '-width=120'], stdout=PIPE, stdin=PIPE, stderr=STDOUT)
            lynx_stdout = p.communicate(input=content_body)[0]
            text = lynx_stdout

            text = text.replace("file://localhost", ud)
            text2 = re.sub(r'\n', r' ', text)
            text2 = re.sub(r'[ ]+',' ', text2)
            text2 = re.sub(r'\[[0-9]+\]', r'', text2)
            text2 = text2.replace("<", "&lt;")
            text2 = text2.replace(">", "&gt;")

#            t.write('<a href="html/'+workfile+'">'+domain+'</a> '+text2)
            # write index data to stdout. This can be redirected to an index file.
            txt += '<li><a href="'+workfile+'">'+domain+'</a><br> '+text2+'</li>\n'
            
            text = re.sub(r'\[([0-9]+)\]', r'[<a href="#\1">\1</a>]', text)
            text = re.sub(r'([ ]*([0-9]+)[.] )http(.*)', r'\1<a href="../index.html#http\3" id="\2">http\3</a>', text)
            f.write(text)
            
        else:
            f.write("[BINARY CONTENT NOT SHOWN]")
        f.write("</pre></body></html>")
        f.close()
        return txt

        


########### END FILE DUMP

    def write_to(self, out, newline='\x0D\x0A', gzip=False):
        if gzip:
            out=GzipFile(fileobj=out)
        self._write_to(out, newline)
        if gzip:
            out.flush()
            out.close()


    def _write_to(self, out, newline):  
        raise AssertionError, 'this is bad'


    ### class methods for parsing
    @classmethod
    def open_archive(cls , filename=None, file_handle=None, mode="rb+", gzip="auto"):
        """Generically open an archive - magic autodetect""" 
        if cls is ArchiveRecord:
            cls = None # means guess
        return open_record_stream(cls, filename, file_handle, mode, gzip)

    @classmethod
    def make_parser(self):
        """Reads a (w)arc record from the stream, returns a tuple (record, errors). 
        Either records is null or errors is null. Any record-specific errors are 
        contained in the record - errors is only used when *nothing* could be parsed"""
        raise StandardError


    



