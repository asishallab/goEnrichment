################################################
# Example input file to R package goEnrichment #
################################################

#' Define background gene set collection
#' [package: GSEABase] - To define your own see [1]
#' See data( package='goEnrichment' ) - every object terminating in '.gsc'
#' can be used.
data("ath_gene_set_collection", package = "goEnrichment") 
gsc <- ath.gsc # Default is TAIR10 GO annotations

#' Define background GO annotations to compare foreground (hypothesis) GO
#' annotations with:
#' See data( package='goEnrichment' ) - every object terminating in '.go' can
#' be used.
data("ath_goa", package = "goEnrichment") 
univ.gene.ids <- as.character(unique(ath.go$V3)) # Default is all TAIR10 GO annotated genes.

#' Load foreground gene IDs, that it those genes for which to identify
#' enriched GO terms. Of course these gene IDs need to be part of the above
#' used Gene Ontolog Annotation table (e.g. 'ath.go').
#' Put in something like the following line - note, that the object 'gene.ids'
#' is REQUIRED:
#' gene.ids <- univ.gene.ids[1:2]

#' Finally define a path to your output table:
output.tbl <- "goEnrichment_output.txt"


#' [1] Define your own gene set collection. Example:
#' require(GOstats)
#' require(GSEABase)
#' univ.go.annos <- read.table( "path/2/go_annos_table.txt", stringsAsFactors=FALSE, sep="\t" )
#' goFrame <- GOFrame(univ.go.annos, organism = "Homo sapiens")
#' goAllFrame <- GOAllFrame(goFrame)
#' gsc <- GeneSetCollection(goAllFrame, setType = GOCollection())
