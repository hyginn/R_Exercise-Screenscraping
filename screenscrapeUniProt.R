# screenscrapeUniProt.R
#
#
# Purpose: sample code to demonstrate R for screenscraping
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

# setwd("<your/project/directory>")

if (!require(XML, quietly =TRUE)) {
    install.packages("XML")
    library(XML)
}



# Fetch the yeast Mbp1 page from Uniprot
queryURL <- "http://www.uniprot.org/uniprot/P39678"
data <- readHTMLTable(queryURL, stringsAsFactors = FALSE)

# That's all we need to do to parse the page and return all table data
# for further processing. The return value is a list of dataframes. Most
# likely the dataframes will contain columns of factors.

data

# The dataframes can be easily accessed as named elements of the list:
names(data)

# It seems the "domainsAnno_section" is what we are looking for.

data$domainsAnno_section

# We can extract the information with our normal R-syntax:
pos <- data$domainsAnno_section[,"Position(s)"]
pos

# Obviously, we would like to get the actual sequence of these domains.
# The protein sequence is however not contained in a table and we have
# to pull it out of the HTML source.

# Let's capture it:

rawHTML <- htmlParse(queryURL)  # This returns an XML node-set
str(rawHTML)

# As we found in the source, the sequence is contained in a <pre>
# element, labelled with class="sequence"

# To extract it from the XML tree in the response object,
# we use the function getNodeSet().
# getNodeSet takes two (or more) parameters: an xml tree, and a "path"
# that describes what nodes should be considered. Paths are expressed
# in the xpath language (see: http://www.w3.org/TR/xpath/). Without
# getting too technical, we use the following notation for the path:
#    //               shorthand for /descendant-or-self::node()/
#    pre()            iterates over all pre nodes and returns a list
#    comment()[<...>] returns a subset of list items, selected by <...>
#    contains(X, Y)   is true if X contains the string in Y
# Once the node set is found, we use toString.XMLNode to convert the
# node into a string.

raw <- toString.XMLNode(
    getNodeSet(rawHTML, "//pre[@class='sequence']")
)
raw

# to assemble the sequence, we need to split this along the
# <br/> elements

lines <- strsplit(raw, "<br/>")[[1]]
lines

# the sequence is in the even lines ...
lines[seq(2, length(lines), by=2)]
# ...and from there we can collapse it:
seq <- paste(lines[seq(2, length(lines), by=2)], collapse="")
# ... and remove the remaining whitespace. gsub() is the base-R
# approach, but the package stringr has more flexible functions:
if (!require(stringr, quiet =TRUE)) {
    install.packages("stringr")
    library(stringr)
}

seq <- str_replace_all(seq, " ", "")
seq

# now all that's left to do is to parse the start and end
# position of the domain, and use a substr() call to get the
# sequence.

getStartEnd <- function(s) {
    return(as.numeric(strsplit(s, "\\s")[[1]][c(1,3)]))
}

for (i in 1:length(pos)) {
    se <- getStartEnd(pos[i])
    s <- substr(seq, se[1], se[2])
    print(paste(se[1], " - ",
                se[2], ": ",
                s))
}


# ====  TASK ====
#    Rewrite the function to provide a structured output object (data frame or
#    list) that contains the element names and attributes and makes them
#    easy to access.


# ====  TASK ====
#    You have heard in the hallway that the XML2 package is a more modern,
#    easier to use alternative to pachage XML. Is that true?
#    Rewrite the code to use XML2.




# [END]
