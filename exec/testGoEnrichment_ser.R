################################################
# Example input file to R package goEnrichment #
################################################

require(goEnrichment)

data( "ath_go_test", package="goEnrichment" )

gsc <- ath.gsc # Default is TAIR10 GO annotations
univ.gene.ids <- as.character(unique(ath.go$V3)[1:1000]) # Default is all TAIR10 GO annotated genes.
gene.ids <- univ.gene.ids[1:2]
output.tbl <- "goEnrichment_test_output_works.tsv"
enrich.gos <- joinGOEnrichResults(goEnrichTest(gsc, gene.ids, univ.gene.ids, cond=TRUE))
write.table(enrich.gos, output.tbl, row.names = FALSE, quote = FALSE, sep = "\t") 
