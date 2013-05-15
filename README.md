Historian-WARC-1
======================

I am just going to be tinkering here. It will create a workflow that brings together wget, WARC Tools, MALLET,
and various visualization tools introduced in _Programming Historian 2_ [http://programminghistorian.org].

If you have any suggestions, comments, etc., please do not hesitate to fork or e-mail. I normally program in <em>Mathematica</em> 
so my Python is a bit rusty. And this is the first time I have scripted in bash.

AT THIS POINT:
- <b>Historian-warc-toolkit.sh</b>
    For this, edit the name of the webpage you want to WARC.
    This script will download it using wget, generate a WARC file, and then generate full-text repositories
    of the website to explore. It then topic models the full text file.

- <b>WARC-to-Stanford.sh</b>
    This script takes the output from the previous one, and puts it into a format that the StanfordHCI/Termite viewer
    can read. It is not pretty, but saves manual formatting. The documentation for that viewer is exceptional and
    helps you install it. [https://github.com/StanfordHCI/termite]

More work coming over the summer.

License
=======
All code in this main directory is by me, made available CC-BY.

Code in WARC directory is taken from older version of WARC-Tools, please note license in their respective
directories.

<b>Ian Milligan</b> [i2milligan@uwaterloo.ca]<br>
Department of History<br>
University of Waterloo, Ontario
