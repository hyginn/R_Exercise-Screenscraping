source("my_rbmBLASTutils.R")


rbmBLAST <- function(qID,
                     from = 1,
                     to = 999999,
                     forSpecies,
                     db = "refseq_protein",
                     eMail,
                     quietly = TRUE) {

    # Purpose:
    #    rbmBLAST.R performs a search of a query sequence in the proteins of a
    #    requested target species in the requested database. It then performs a
    #    reverse search with the top-hit (by E-value) in the genome of the query
    #    species. The key results are returned in the output list.
    #
    # Version: 0.0
    # Date:    2016-09
    # Author:  NN
    #
    # Parameters:
    #     qID: <character> ID of query. Must be present in requested database.
    #     from: <integer> deines subsequence
    #     to: <integer>
    #     forSpecies: <character> binomial name
    #     db: <character> NCBI database requested for search
    #     eMail: <character>
    #     quietly: <logical> suppres status output
    # Value:
    #     out: <list>
    #          $hasRBM  - <logical> TRUE if fID has an RBM in the target species
    #          $FOR     - list collecting all key results of the forward search
    #          $REV     - list collecting all key results of the reverse search


    # Initialize output structure
    out <- list()

    out$hasRBM <- FALSE   # We set this to TRUE if the search for an RBM is
    # successful.

    # Initialize parmaters for BLAST search
    #
    nHits <- 1 # We could increase this to capture information about nonRBMs
    # For a "classic" RBM we only need the top hit though ...

    Evalue <- 3  # If hits are less significant  than 1:1000 we should
    # not simply assume they are orthologous,
    # even if they happen to be RBMs. Better
    # to be conservative ...


    # Construct URL for forward query
    URLrequest <- paste(
        "http://www.ncbi.nlm.nih.gov/blast/Blast.cgi",
        "?",
        "QUERY=", qID,
        "&QUERY_FROM=", as.character(from),
        "&QUERY_TO=", as.character(to),
        "&DATABASE=", db,
        "&HITLIST_SIZE=", as.character(nHits),
        "&EXPECT=", as.character(Evalue),
        "&PROGRAM=", "blastp",
        "&ENTREZ_QUERY=", sprintf("\"%s\"[organism]", forSpecies),
        "&NOHEADER=", "true",               # turn off graphic header in result
        "&EMAIL=", eMail,
        "&CMD=Put",
        sep = "")

    # Pass URL string to a BLAST function that will send off the query
    # and parse the results. Assign results to a list in the output object.
    out$FOR <- BLASTandParse(URLrequest, quietly = quietly)

    # Create query for reverse search, populating parameters from the results
    # of the forward search.
    URLrequest <- paste(
        "http://www.ncbi.nlm.nih.gov/blast/Blast.cgi",
        "?",
        "QUERY=", out$FOR$hit_accession,
        "&QUERY_FROM=", out$FOR$hsp_hit.from,
        "&QUERY_TO=", out$FOR$hsp_hit.to,
        "&DATABASE=", db,
        "&HITLIST_SIZE=", as.character(nHits),
        "&EXPECT=", as.character(Evalue),
        "&PROGRAM=", "blastp",
        "&ENTREZ_QUERY=", sprintf("\"%s\"[organism]", out$FOR$querySpecies),
        "&NOHEADER=", "true",               # turn off graphic header in result
        "&EMAIL=", eMail,                   # contact address
        "&CMD=Put",
        sep = "")

    out$REV <- BLASTandParse(URLrequest, quietly = quietly)

    # Now compare forward and reverse results:
    # Careful: we need to remove version numbers ...
    fID <- strsplit(out$FOR$queryID, "\\.")[[1]][1]
    rID <- strsplit(out$REV$hit_accession, "\\.")[[1]][1]

    # Successful RBM if forward query and reverse best-hit are the same
    # sequence.  If that's the case, write this into the result object.
    if (fID == rID) {
        out$isRBM <- TRUE
    }

    # Done
    return(out)
}



# === Tests ===
#
TEST <- list(qID = "NP_010227",
             from = 4,
             to = 102,
             db = "refseq_protein",
             tSpecies = "bipolaris oryzae",
             eMail = "boris.steipe@utoronto.ca")

rbm1 <- rbmBLAST(qID = TEST$qID,
                from = TEST$from,
                to = TEST$to,
                db = TEST$db,
                forSpecies = TEST$tSpecies,
                eMail = TEST$eMail)

rbm2 <- rbmBLAST(qID = TEST$qID,
                forSpecies = "Kluyveromyces lactis",
                eMail = TEST$eMail)


# [END]
