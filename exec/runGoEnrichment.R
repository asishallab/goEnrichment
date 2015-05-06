require(goEnrichment)

# Hail User:
message("Usage: Rscript path/2/goEnrichment/exec/runGoEnrichment.R input.R")
message("Find an example input file here: path/2/goEnrichment/input.R")

# Load input
source(commandArgs(trailingOnly = TRUE)[[1]])

# Run analysis
enrich.gos <- joinGOEnrichResults(goEnrichTest(gsc, gene.ids, univ.gene.ids, cond = TRUE))

# Write output:
write.table(enrich.gos, output.tbl, row.names = FALSE, quote = FALSE, sep = "\t") 
