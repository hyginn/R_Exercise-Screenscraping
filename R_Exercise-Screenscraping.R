# R_Exercise-Screenscraping.R
#
# Purpose: Introduction to screenscraping with R for Applied Bioinformatics
#
# Version: 1.1
#
# Date:    2016  09  26
# Author:  Boris Steipe (boris.steipe@utoronto.ca)
#
# V 1.1    Added files for RBM BLAST assignment
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
# it would be less work to try to parse images, than to contact the maintainers
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
#  - How do we do the same thing we did above in R using rcurl?
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
# ==== TASK ====
# How do you use regular expressions in R?
# cf.  http://steipe.biochemistry.utoronto.ca/abc/index.php/Regular_Expressions
#
#
# ==== TASK ====
# Now work through the "screenscrapeUniProt.R" script in this project.
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
# Open and work through the "simpleBLASTsearch.R" script in this project.
#

# ==== Exercises ====
#    Write a function to retrieve a real random number from the server at
#    random.org. Give it the same signature as the function runif() in base R.
#

# === ASSIGNMENT ===============================================================
#
# Finding RBMs is a straightforward procedure, when done by hand. But it is
# also quite tedious, when done for a number of sequences (e.g. all APSES
# domain proteins of saccharomyces cerevisiae) or in a number of species
# (e.g. all fungi), or both (e.g. when building orthologous groups in a
# domain family).
#
# # Write the function rbmBLAST() that finds the RBM to
# a sequence using the NCBI BLAST server. You can put the function into a file
# rbmBLAST.R - I have not included a file by that name in the project so there
# won't be a conflict in case you pull updated versions of this project from
# github. Details are in the specification below; note that you are to find
# RBMs for sub-sequences, eg. the APSES domain of a transcription factor. This
# is slightly more involved than simply getting RBMs for entire genes, since
# we need to work with actual sequence for the forward and reverse search, not
# just database IDs.
#
# Don't duplicate code: the forward and reverse search are essentially
# the same procedure, so the procedure should be defined as a function that
# you call with the appropriate parameters. You can build this largely from
# code you find in simpleBLASTsearch.R Put this function and other helper
# functions you need into a separate file, you could call this
# my_rbmBLASTutils.R
#
# Nb. Why is this a "screenscraping" assignment, when we actually use the
# BLAST API? Simply because the mechanics are the same: use an URL string
# to get a server to respond, and parse the response HTML or XML that you
# receive.
#
#
# === Specification   ===
#
# Description:

#    rbmBLAST.R performs a search of a query sequence in the proteins of a
#    requested target species in the requested database. It then performs a
#    reverse search with the top-hit (by E-value) in the genome of the query
#    species. The key results are returned in the output list.

#
# Input parameters:
#    qID: <character>
#    from: <integer>
#    to: <integer>
#    forSpecies: <character>
#    db: <character>
#    eMail: <character>
#    quietly: <logical>
#
# Output: a list with the following components:
#    $hasRBM  - <logical> TRUE if fID has an RBM in the target species
#    $FOR     - list collecting all key results of the forward search
#    $REV     - list collecting all key results of the reverse search
#
#
# Notes:
#
#    qID: query ID, must be a valid protein sequence ID in the database db. No
#         default. The query species should be obtained from the result of the
#         _forward_ search with qID, this implies that qID should be valid in
#         db.
#
#    from / to: <integer> positions in the sequence defined by query ID that
#               define the range of the actual query.
#
#               The function should be able to find the RBM for a substring in
#               the sequence. Evolution acts on domains, and being able to
#               restrict an RBM search to a particular domain is much more
#               meaningful than being restricted to work with full-length
#               sequences. If the parameters from / to are missing, make sure to
#               still generate valid URL request strings. The simplest way is to
#               set "from" to 1, "to" to a large integer and thereby search with
#               the full-length sequence.
#
#    db: the database that the search should be performed in. Default to
#        "refseq_protein". Other valid strings that BLAST accepts are:
#        "nr", "pdb", "swissprot"; of course "pdb" is not a valid choice for
#        an RBM search.
#
#    forSpecies: the species in which the RBM is to be found. Note that the
#                query species is implied by the query ID (qID) and should be
#                inferred from the information returned by the server for the
#                reverse search. If the query species is not a genome-sequenced
#                species, the search results can not be interpreted as an RBM.
#                However that is a semantic constraint on the input, not a
#                structural constraint.
#
#   eMail: a valid eMail drress to identify you
#
#   quietly: BLAST searches can take several minutes. Provide feedback what the
#            search is doing, but use this paramater to turn off the feedback.
#            Default to TRUE (feedback off).
#

# === Assignment Hints =========================================================
#
# In principle, you should be able to implement the function based on the
# specification. To help you with the BLAST output, I have provided the file
# BLASTresponse.xml that makes it easier to see what xml nodes will be present.
#
# Here are some additional hints:
#
# 1: - rbmBLASTtemplate.R   A template for the function code. This is just for
#                           helping you structure and saving some typing.
#
# 2: - rbmBLASTpseudo.R     Pseudocode for the function. Try to write this
#                           yourself first.
#
# 3: - rbmBLASTmain.R       An implementation of the function.
#    - rbmBLASTutils.R      Implementations of helper functions and utilities.
#                           But try to write the implementations yourself
#                           first.

#  Taken together, the code in rbmBLASTmain.R and rbmBLASTutils.R constitute a
#  valid solution. By all means, try your own solution first, based
#  only on the template script (possibly improving on that). Write out your
#  pseudocode first. Then check your pseudocode against the code I provided. If
#  it's essentially the same, implement it. If you have overlooked something,
#  fix it. If your pseudocode is better - great! Post this in the list so we can
#  resolve.

#  Proceed the same way for the implementation. I usually code a task
#  like this by first writing dummy functions that have the correct signature
#  but simply return constants from their code. Once the structure of the code
#  is established, I add the proper logic to the functions.

# === Optional: ===
#  If you want to improve your function further, you could:
#    - add an option <logical> "BLASTrank" to return the rank of the hit in
#      the forward and reverse search results, respectively;
#    - add a shortcut argument <logical> checkOnly that makes your function
#      return only TRUE/FALSE when run with two sequence IDs and a forward
#      range (build this from the BLASTrank output). Note that you need to infer
#      the species for both IDs in this case. Good if you have abstracted your
#      code so that this is easy;
#    - I have done nothing to handle results with more than one hsp. A
#      robust function would need that. The proper logic is not trivial
#      however;
#    - think of what kind of error checking a function like this would need;
#    - check the documentation of the Bioconductor's annotater package. It
#      contains BLAST functions. Are they better?

#
# Have fun!

# [END]
