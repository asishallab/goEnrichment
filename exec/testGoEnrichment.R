################################################
# Example input file to R package goEnrichment #
################################################

require(GOstats)
require(GSEABase)
require(RMySQL)
source( "../R/goEnrichment.R" )
# require(goEnrichment)

#' Define background gene set collection
#' [package: GSEABase] - To define your own see [1]
#' See data( package='goEnrichment' ) - every object terminating in '.gsc'
#' can be used.
# load( "~/R_libs/goEnrichment/data/ath_gene_set_collection.RData" )
data( "ath_gene_set_collection", package="goEnrichment" )
gsc <- ath.gsc # Default is TAIR10 GO annotations

#' Define background GO annotations to compare foreground (hypothesis) GO
#' annotations with:
#' See data( package='goEnrichment' ) - every object terminating in '.go' can
#' be used.
load( "~/R_libs/goEnrichment/data/ath_goa.RData" )
data( "ath_goa", package="goEnrichment" )
univ.gene.ids <- as.character(unique(ath.go$V3)[1:1000]) # Default is all TAIR10 GO annotated genes.

#' Load foreground gene IDs, that it those genes for which to identify
#' enriched GO terms. Of course these gene IDs need to be part of the above
#' used Gene Ontolog Annotation table (e.g. 'ath.go').
#' Put in something like the following line:
gene.ids <- univ.gene.ids[1:2]

#' Finally define a path to your output table:
output.tbl <- "goEnrichment_test_output.tsv"

# Run analysis
enrich.gos <- joinGOEnrichResults(goEnrichTest(gsc, gene.ids, univ.gene.ids, cond=TRUE))

# Write output:
write.table(enrich.gos, output.tbl, row.names = FALSE, quote = FALSE, sep = "\t") 
