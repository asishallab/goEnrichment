require(goEnrichment)

data("ath_go_test", package = "goEnrichment")
data("ath_gene_set_collection_test", package = "goEnrichment")

univ.gene.ids <- as.character(unique(ath.go.tst$V3))
gene.ids <- univ.gene.ids[1:2]
output.tbl <- "goEnrichment_test_output_fail.tsv"
enrich.gos <- joinGOEnrichResults(goEnrichTest(ath.gsc.tst, gene.ids, univ.gene.ids, 
  cond = TRUE))
write.table(enrich.gos, output.tbl, row.names = FALSE, quote = FALSE, sep = "\t") 
