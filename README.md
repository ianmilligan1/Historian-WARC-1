Historian-WARC-1
======================

Blog post here: http://ianmilligan.ca/2013/05/15/warc-to-topic-models/ and additional documentation on running it all
together on the command line here: http://ianmilligan.ca/2013/05/24/putting-it-all-together-warc-to-output/

I obviously didn't write WARC tools, as the license shows. Websites for them are here 
http://code.hanzoarchives.com/warc-tools and http://mandal.ca/web.cgi/HelpOnWarcTools. The latter
has seen functionality change, so I have included an older version that works with my program.

If you have any suggestions, comments, etc., please do not hesitate to let me know.

Purpose
=======

The purpose of this code is to take a WARC file, either downloaded from somewhere else or created using wget, and
do the following:<br/>
<ol>
<li>Turn it into a <b>full-text searchable repository</b> using WARC-Tools;</li>
<li><b>Topic model the full-text</b> using MALLET;</li>
<li>Generate an analysis of the file allowing you to pick from a <b>repository of various visualizations</b> to learn
what you want to learn from the file. By default this is a PDF w/
<ul>
<li>Name of Website
<li>Date of Scrape
<li>Short Preview
<li>Word Cloud
<li>Keyword-in-Context of a Word Specified When Calling Program
<li>Topic Models with Sparklines to show distribution of topic across the WARC file.
</ol>        

Requirements
============
<ul>
<li>OS X or Linux
<li>Mathematica (tested on 9, should work with 8)
<li>Mallet 2.0.7 (http://mallet.cs.umass.edu)
</ul>

How to Call It
==============

<code>sh ./WARC-to-Analysis.sh [WARC] ["KWIC WORD"]</code>

Where [WARC] is the name of your file and the ["KWIC WORD"] is the word you want to analyze in the default KWIC visualization.

i.e.

<code>sh ./WARC-to-Analysis.sh ianmilligan.warc "history"</code>

Will run it.

Setup
=====
<ol>
<li>Set the path in WARC-to-Analysis.sh, line 33, to the path where filesdump.py is installed. That file is contained
within the WARC folder in this repository.
<li>Set the path to MALLET on line 38, 39. Follow MALLET instructions: http://programminghistorian.org/lessons/topic-modeling-and-mallet
<li>Set alias to your MathKernel on line 63 in WARC-to-Analysis.sh if it is not installed in default Applications directory.
<li>Only relevant change in WARC-to-Analysis-Mathematica should be the distance= variable. Set to see how far in to the WARC file you want to go. By default, reads first five entires for preview/word cloud purposes. More is better.


Other Tools
===========

Another script in this repository takes you from a WARC file (which is wgetted by default) and formats it for the 
Stanford HCI/Termite viewer. See these ones:

- <b>WARC-to-Stanford.sh</b>
    This script takes the output from the previous one, and puts it into a format that the StanfordHCI/Termite viewer
    can read. It is not pretty, but saves manual formatting. The documentation for that viewer is exceptional and
    helps you install it. [https://github.com/StanfordHCI/termite]

- <b>All-Together.sh</b>
    This puts it all together, so you can theoretically change some of the variables and in one click go from 
    taking a WARC of a website and put it into the StanfordHCI/termite viewer. This one also includes the comamnds
    to initialize Termite if it's in the same directory.

<b>Ian Milligan</b> [i2milligan@uwaterloo.ca]<br>
Department of History<br>
University of Waterloo, Ontario

License

All code in this main directory is by me, made available CC-BY.

Code in WARC directory is taken from older version of WARC-Tools, please note license in their respective
directories.
