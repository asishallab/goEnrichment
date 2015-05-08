#############################################
# TEST input file to R package goEnrichment #
#############################################
#' Run test with: 
#' Rscript path/2/goEnrichment/exec/runGoEnrichment.R test_input.R

#' Define background gene set collection
data("ath_gene_set_collection_test", package = "goEnrichment") 
gsc <- ath.gsc.tst

#' Define background GO annotations to compare foreground (hypothesis) GO
#' annotations with:
data("ath_go_test", package = "goEnrichment") 
univ.gene.ids <- sort(unique(ath.go.tst$V3))[1:1000]

#' Foreground gene ids:
gene.ids <- univ.gene.ids[1:20]

#' Finally define a path to your output table:
output.tbl <- "goEnrichment_output.txt"
