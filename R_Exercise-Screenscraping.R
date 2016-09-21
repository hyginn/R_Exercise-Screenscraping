# R_Exercise-Screenscraping.R
#
# Purpose: Introduction to screenscraping with R for Applied Bioinformatics
#
# Version: 1.0
#
# Date:    2016  09  21
# Author:  Boris Steipe (boris.steipe@utoronto.ca)
#
# V 1.0    First code
#
# TODO:
#
#
# == HOW TO WORK WITH THIS FILE ======================================
#
#  Go through this script line by line to read and understand the
#  code. Execute code by typing <cmd><enter>. When nothing is
#  selected, that will execute the current line and move the cursor to
#  the next line. You can also select more than one line, e.g. to
#  execute a block of code, or less than one line, e.g. to execute
#  only the core of a nested expression.
#
#  Edit code, as required, experiment with options, or just play.
#  Especially play.
#
#  DO NOT simply source() this whole file!
#
#  If there are portions you don't understand, use R's help system,
#  Google for an answer, or ask me. Don't continue if you don't
#  understand what's going on. That's not how it works ...
#
#  This is YOUR file. Write your notes in here and add as many
#  comments as you need to understand what's going on here when you
#  come back to it in a year. That's the right way: keep code, data
#  and notes all in one place.
#
# ====================================================================

# Screenscraping is a highly informal method of parsing HTML output for data.

# The right way to work with programs on non-local hosts is through simple RPC
# (remote procedure calls) or APIs (Application Program Interfaces) that may
# include more complex objects or datastructures. In fact, the contents of
# webpages has changed dramatically from the simple HTML we would have seen even
# a few years ago, to highly dynamic containers of elaborate Javascript programs
# that assemble their information payload client-side, often from multiple
# sources. For such pages, API access is likely to be the only sensible way, and
# reverse engineering such output would be a major project. However many less
# sophisticated sites give us simpler output and we need to work with what we
# have: the contents of a Webpage. Taking a server's HTML output and parsing the
# relevant data-elements from it is therefore often called screenscraping. It is
# generally used:
#
#  - when data is available only through a Web-server;
#  - when no formal specifications for the data and or procedures exist or
#    are not easily available;
#  - when robust access and reproducible behaviour are of less importance
#    than speed of deployment.
#
# Screen scraping is therefore highly informal and ad hoc - a quick and dirty
# solution to common tasks.
#
# In principle, the process divides into two parts:
#
#   1: accessing data
#   2: parsing the information of interest
#

# == ACCESSING DATA ============================================================

# Let us assume our data of interest is textual data - I could not imagine that
# it would be less work to try to parse images than to contact the maintainers
# of the data and negotiate a proper interface.

# == Web browser

# Usually the starting point of your development. Simply navigate to a page,
# then save it as HTML or text-only, or view the source to analyze it. It's
# often easier to work with HTML than with the visible text of a page because
# the markup may simplify parsing. Let's access the domain information for the
# yeast Mbp1 cell cycle regulator at Uniprot. The UniProt ID of the protein is
# P39678 and we can directly access information for a protein at Uniprot with
# this knowledge:

# In your browser, open http://www.uniprot.org/uniprot/P39678
#
# Let's access and interpret start and end coordinates for the annotated
# domains. First, the  HTML source. Open it and have a look.

# It is certainly quite messy - but it seems well enough structured to work with
# it. We could copy and paste it and take it apart ...

# == wget
#
# Better is to download the page directly. wget is a Unix command line interface
# to network protocols. It is simple to use to download the Mbp1 Uniprot page:
# open a terminal, type
#
# $  which wget
#
# ... to make sure wget is installed, then type
#
#
# $  wget -O - http://www.uniprot.org/uniprot/P39678
#
# If a file name is specified instead of "-", the output will be written to that
# file instead of STDOUT. If -O is not specified, the output will be written to
# a file in the local directory with the same name as the file on the server.
#
# == curl
#
# curl is an alternative to wget. For a comparison of the two see
# https://daniel.haxx.se/docs/curl-vs-wget.html
# curl's syntax is "cleaner" unix, and it supports redirects and pipes. In your
# terminal type:
#
# $  curl http://www.uniprot.org/uniprot/P39678 > P39678.html
# $  head P39678.html
#
# == Rcurl
#
# TASK:
# There is a library called "rcurl".
#  - What does it do?
#  - How do we do the same thing we did above in R?
#
#  == httr
#
# TASK:
#  There is a more modern alternative to curl called httr.
#  What about that?
#   ( https://cran.r-project.org/web/packages/httr/vignettes/quickstart.html )

# == PARSING DATA ==============================================================

# To parse anything meaningful from the raw code you have retrieved, you will
# need Regular_Expressions ... or you may need to parse with a "real" XML-aware
# parser. When to do what? see here:
# http://stackoverflow.com/questions/1732348/regex-match-open-tags-except-xhtml-self-contained-tags/1732454#1732454
#
# But sometimes we do it anyway.
#
# TASK:
# How do you use regular expressions in R?
#
#
# ====  TASK ====
# Now let's work through the "screenscrapeUniProt.R" script in this project.
#

# == Automation ==
#
# What if you want to extract data from multiple pages? What if the data is
# dynamically generated as a result to a query and you don't know the URL? What
# if you simply need much more control over your data retrieval? You will need
# to write some code that emulates user behaviour, essentially a bot, or spider.
# Note that there may be legal issues involved in doing so (For a discussion of
# the legal issues see e.g. Web scraping on Wikipedia -
# https://en.wikipedia.org/wiki/Web_scraping).

# ====  TASK ====
# Open and workt hrough the "simpleBLASTsearch.R" script in this project.
#



# ====  TASK ====
#    Write a function to retrieve a real random number from




# [END]
