# rbmBLASTtemplate.R
#
# Purpose:  run a Reciprocal Best Match (RBM) search via the NCBI's
#           BLAST API.
#
# ToDo:
# Notes:
#
# ==============================================================================

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

    # code ...

	return(out)
}



# ====  TESTS  =================================================================
# ...


# [END]
