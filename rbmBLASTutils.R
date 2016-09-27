# functionTemplate.R
#
# Purpose:  (General)
#
# ToDo:
# Notes:
#
# ==============================================================================

# ==== Initialize ==============================================================
#  === to handle XML ====
if (!require(XML, quietly = TRUE)) {
    install.packages("XML")
    library(XML)
}

# === for trimming whitespace ===
if (!require(stringr, quietly = TRUE)) {
    install.packages("stringr")
    library(stringr)
}

# === Functions ================================================================

node2string <- function(doc, s) {
    path <- paste("//", s, "/text()", sep="")
    return(str_trim(toString.XMLNode(getNodeSet(doc, path)[[1]])))
}


node2num <- function(doc, s) {
    return(as.numeric(node2string(doc, s)))
}


def2Species <- function(def) {
    # parse and return a binomial species name from a sequence defline
    s <- unlist(strsplit(def, "[]\\[]"))[2]
    s <- paste(unlist(strsplit(s, "\\s+"))[1:2], collapse=" ")
    return(s)
}


BLASTandParse <- function(URL, quietly = TRUE) {

    out <- list()
    eMail <- regmatches(URL, regexec("EMAIL=(.+)&"  , URL))[[1]][2]

    # send query, capture response
    response <- htmlParse(URL)

    # parse rid and rtoe from response
    info <- toString.XMLNode(
        getNodeSet(response, "//comment()[contains(., \"QBlastInfo\")]"))
    RID  <- regmatches(info, regexec("RID = (\\w+)"  , info))[[1]][2]
    RTOE <- as.numeric(regmatches(info, regexec("RTOE = (\\d+)" , info))[[1]][2])

    # sleep for RTOE seconds, then retrieve result
    if (! quietly) {
        cat(sprintf("BLASTandParse() > RID is %s , sleeping for %d seconds.\n",
                    RID, RTOE))
    }
    Sys.sleep(RTOE)
    ridURL <- paste(
        "http://www.ncbi.nlm.nih.gov/blast/Blast.cgi",
        "?",
        "RID=", RID,    # the request ID
        "&FORMAT_TYPE=", "XML",
        "&EMAIL=", eMail,
        "&CMD=Get",
        sep = "")
    response <- htmlParse(ridURL)

    if (length(getNodeSet(response, "//hit")) != 1) {
        stop(sprintf("Sent request %s after waiting %d seconds but %s.",
                     ridURL,
                     RTOE,
                     "response was not exactly one hit"))
    }

    if (length(getNodeSet(response, "//hsp")) != 1) {
        stop(sprintf("Response for request %s (%s) contained %d hits, but %s.",
                     ridURL,
                     RID,
                     length(getNodeSet(result, "//hsp")),
                     "this code can only handle exactly one hsp"))
    }

    # Parse server response
    out$URLrequest  <- URL
    out$queryID <- node2string(response, "blastoutput_query-id")
    out$queryDef <- node2string(response, "blastoutput_query-def")
    out$querySpecies <- def2Species(out$queryDef)
    out$hit_accession  <- node2string(response, "hit_accession")
    out$hit_def        <- node2string(response, "hit_def")
    out$hsp_evalue     <-    node2num(response, "hsp_evalue")
    out$hsp_query.from <-    node2num(response, "hsp_query-from")
    out$hsp_query.to   <-    node2num(response, "hsp_query-to")
    out$hsp_hit.from   <-    node2num(response, "hsp_hit-from")
    out$hsp_hit.to     <-    node2num(response, "hsp_hit-to")
    out$hsp_identity   <-    node2num(response, "hsp_identity")
    out$hsp_align.len   <-   node2num(response, "hsp_align-len")
    out$hsp_qseq       <- node2string(response, "hsp_qseq")
    out$hsp_hseq       <- node2string(response, "hsp_hseq")
    out$hsp_midline    <- node2string(response, "hsp_midline")

    return(out)
}




# ====  TESTS  =================================================================
# Enter your function tests here...


# [END]
