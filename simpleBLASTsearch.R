# simpleBLASTsearch.R
#
# Purpose: Tutorial code to send off one BLAST search
#          This script uses the BLAST URL-API
#          (Application Programming Interface) at the NCBI.
#          Read about the constraints here:
# http://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=DeveloperInfo
#
#
# Version: 1.0
# Date:    2016-09-21
# Author:  Boris Steipe
#
# Input:
# Output:
# Dependencies:
#
# ToDo:
# Notes:
#
# ==============================================================================


# We will send off one BLAST search for the APSES domain of the Mbp1
# transcription factor of saccahromyces cerevisiae..

# The bioconducter "annotate" package contains code for BLAST searches,
# in case you need to do something more involved.


# ====== Basic parameters ============================================

emailAddress <- "<your.name>@<your.host>"


# ====== The query ===================================================
# Queries can be either sequences, or database IDs. In case you
# use a numeric database ID - like a GI number - you might wrap
# the ID in as.character() to be sure the query is passed as a string.

# the APSES domain of P39678 (yeast Mbp1)
querySeq   <- paste("IYSARYSGVDVYEFIHSTGSIMKRKKDDWVNATHI",
                    "LKAANFAKAKRTRILEKEVLKETHEKVQGGFGKYQ",
                    "GTWVPLNIAKQLAEKFSVYDQLKPLFDFTQTDGSASP",
                    sep="")


# ====== The Entrez restriction ======================================
# Entrez restrictions work in the usual way: you can specify an
# organism as a binomial (eg. "saccaromyces cerevisiae"[organism]), or
# as an NCBI taxonomy ID (e.g. txid4932[organism]). For details and
# options see the Search Builder section of the Advanced Search
# interface of any query at the NCBI.

# ====== The command URL =============================================
# To use the BLAST URL API, we specify the required parameters in an
# URL string. See the extensive documentation on the possible
# parameters at
# http://www.ncbi.nlm.nih.gov/blast/Doc/urlapi.html

# I separate commands and arguments in the code below, so they are
# easy to replace with other strings or variables.

queryURL <- paste(
    "http://www.ncbi.nlm.nih.gov/blast/Blast.cgi",
    "?",
    "QUERY=", querySeq,
    "&DATABASE=", "refseq_protein",         # or: nr, pdb, swissprot ...
    "&HITLIST_SIZE=", "30",
    "&EXPECT=", "3",                        # hit probably meaningless if E-value worse
    "&PROGRAM=", "blastp",                  #
    "&ENTREZ_QUERY=", paste("\"saccharomyces cerevisiae\"[organism]", sep=""),
    "&NOHEADER=", "true",                   # turn off graphic header in result
    "&EMAIL=", emailAddress,                # contact address for problem feedback
    "&CMD=Put",
    sep = "")

# ====== Sending the URL off to BLAST ================================
# To communicate over the Internet, we need functions to post a query
# and receive results. These can be found in the XML package.

if (!require(XML)) {
    install.packages("XML")
    library(XML)
}

# send the query string off, and capture the response.

response <- htmlParse(queryURL)


# The response contains two items we need to continue:
# RID - the request ID. With this ID we can retrieve results
#       from the BLAST server.
# RTOE - the expected time to complete.
# We extract these two items from the response, to be able
# to construct further queries to pick up the results.
# They are contained in a comment of the returned HTML document:
#   <!--QBlastInfoBegin
#      RID = 7W7M0JM4015
#      RTOE = 27
#   QBlastInfoEnd
#   -->

# To extract the comment from the XML tree in the response object,
# we use the function getNodeSet().
# getNodeSet takes two (or more) parameters: an xml tree, and a "path"
# that describes what nodes should be considered. Paths are expressed
# in the xpath language (see: http://www.w3.org/TR/xpath/). Without
# getting too technical, we use the following notation for the path:
#    //               shorthand for /descendant-or-self::node()/
#    comment()        iterates over all comments and returns a list
#    comment()[<...>] returns a subset of list items, selected by <...>
#    contains(X, Y)   is true if X contains the string in Y
# Once the node set is found, we use toString.XMLNode to convert the
# node into a string.

info <- toString.XMLNode(
    getNodeSet(response, "//comment()[contains(., \"QBlastInfo\")]")
)

# Finally we use regular expression matching to extract the information we need.
rid  <- regmatches(info, regexec("RID = (\\w+)" , info))[[1]][2]
rtoe <- as.numeric(regmatches(info, regexec("RTOE = (\\d+)" , info))[[1]][2])
rid
rtoe
# Now: we sleep for rtoe seconds, then we access the result by querying
# for the request ID.

ridURL <- paste(
    "http://www.ncbi.nlm.nih.gov/blast/Blast.cgi",
    "?",
    "RID=", rid,                # the request ID
    "&FORMAT_TYPE=", "XML",
    "&EMAIL=", emailAddress,
    "&CMD=Get",
    sep = "")

Sys.sleep(rtoe)
result <- htmlParse(ridURL)

# The rtoe number of seconds is an estimate - our query may or may not be done in
# time. If it's not done, there will be no element <hit> ... </hit> in the result.

length(getNodeSet(result, "//hat"))  # should be zero - no such node
length(getNodeSet(result, "//hit"))  # will be > 0 when the result has returned

# Run interactively, we may simply try multiple times to get the result.
# When we put everything together as a function, we'll poll for the result
# at regular intervals or until a timeout limit is reached.
# But you have to be careful: when you script this, you might generate
# too many requests in a given time interval, and the NCBI might block
# your IP address! Here is the NCBI usage policy:
# http://www.ncbi.nlm.nih.gov/staff/tao/URLAPI/new/node2.html
# In a nutshell: don't submit more than three jobs per second, and
# don't poll for the same RID more frequently than in minute intervals.
#
# Please take this seriously: not only is it a discourtesy not to
# comply, but getting e.g. your lab's IP blocked by the NCBI is going
# to be a bit of a problem going forward.
#
# Once the result is available, we can parse it for the data we need and
# populate our list. Examine the contents of the hit:

getNodeSet(result, "//hit")

# Done

# [END]

