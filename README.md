Historian-WARC-1
======================

Blog post here: http://ianmilligan.ca/2013/05/15/warc-to-topic-models/

I am just going to be tinkering here. It will create a workflow that brings together wget, WARC Tools, MALLET,
and various visualization tools introduced in _Programming Historian 2_ [http://programminghistorian.org].

If you have any suggestions, comments, etc., please do not hesitate to let me know.

AT THIS POINT:
- <b>Historian-warc-toolkit.sh</b>
    For this, edit the name of the webpage you want to WARC.
    This script will download it using wget, generate a WARC file, and then generate full-text repositories
    of the website to explore. It then topic models the full text file.

- <b>WARC-to-Stanford.sh</b>
    This script takes the output from the previous one, and puts it into a format that the StanfordHCI/Termite viewer
    can read. It is not pretty, but saves manual formatting. The documentation for that viewer is exceptional and
    helps you install it. [https://github.com/StanfordHCI/termite]

- <b>All-Together.sh</b>
    This puts it all together, so you can theoretically change some of the variables and in one click go from 
    taking a WARC of a website and put it into the StanfordHCI/termite viewer. This one also includes the comamnds
    to initialize Termite if it's in the same directory.

More work coming over the summer.

<b>Ian Milligan</b> [i2milligan@uwaterloo.ca]<br>
Department of History<br>
University of Waterloo, Ontario

License

All code in this main directory is by me, made available CC-BY.

Code in WARC directory is taken from older version of WARC-Tools, please note license in their respective
directories.
