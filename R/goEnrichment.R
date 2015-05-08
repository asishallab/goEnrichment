#' Computes a Gene Ontology (GO) enrichment test using the functions from
#' package GOstats and GSEABase.
#'
#' @param gsc An instance of gene set collection [package GSEABase]
#' @param gene.ids A character vector of gene IDs among which to look for
#'        enriched GO terms
#' @param univ.gene.ids A character vector of 'background' gene IDs to be used
#'        as reference GO annotations when looking for overrepresentations in
#'        'gene.ids'
#' @param ontologies A character vector of the Gene Ontology categories to
#'        compute enrichment tests for, default is 'BP', 'CC', and 'MF'
#' @param pvalue.cutoff The significance level, default to 0.01
#' @param cond If set to TRUE already found to be enriched GO annotations wont
#'        be counted when testing enrichment for parental terms, default is
#'        FALSE
#' @param test.dir Set to 'over' to infer overrepresentation, set to 'under'
#'        if the opposite is wanted.
#' @param p.adjust.method The method used to adjust p-values for multiple
#'        hypothesis testing, default is 'fdr'. See function p.adjust for
#'        details.
#'
#' @return A named list with enriched GO terms in the argument GO categories.
#' @export
#' @import GOstats GSEABase
goEnrichTest <- function(gsc, gene.ids, univ.gene.ids, ontologies = c("BP", "CC", 
  "MF"), pvalue.cutoff = 0.01, cond = FALSE, test.dir = "over", p.adjust.method = "fdr") {
  setNames(lapply(ontologies, function(go.ont) {
    tryCatch({
      ghgr <- GOstats::hyperGTest(Category::GSEAGOHyperGParams(name = "", geneSetCollection = gsc, 
        geneIds = gene.ids, universeGeneIds = univ.gene.ids, ontology = go.ont, 
        pvalueCutoff = pvalue.cutoff, conditional = cond, testDirection = test.dir))
      procGOHyperGResult( ghgr, pvalue.cutoff )
    }, error = function(e) {
      warning("Error in goEnrichTest(...) when computing GO-Ontology ", go.ont, 
        " ", e)
      NA
    })
  }), ontologies)
} 


#' Converts an instance of GOHyperGResult into a table containing only the
#' significantly enriched Gene Ontology terms.
#'
#' @param ghgr The instance of GOHyperGResult to process
#' @param pvalue.cutoff The significance level to be applied
#'
#' @return A data.frame with three columns: 1. 'GO.term', 2. 'p.value', and 3.
#'         'GO.category' - or NULL if no significantly enriched GO terms were
#'         found.
#' @export
#' @import GO.db
procGOHyperGResult <- function(ghgr, pvalue.cutoff = 0.01) {
  go.ont <- strsplit(ghgr@testName, " ")[[2]]
  x.pv <- pvalues(ghgr)
  x.res <- x.pv[which(x.pv <= pvalue.cutoff)]
  if (length(x.res) > 0) {
    x.go.names <- as.character(lapply(names(x.res), function(go.acc) {
      go.term <- GO.db::GOTERM[[go.acc]]
      if (!is.null(go.term)) go.term@Term
    }))
    data.frame(GO.term = names(x.res), GO.category = go.ont, GO.name = x.go.names, 
      p.value = as.numeric(x.res), stringsAsFactors = FALSE)
  } else NULL
} 

#' Method extracts all GO ontology specific enrichment result and combines them
#' into a single data frame, re-adjusting the Pvalues for multiple hypothesis
#' testing.
#'
#' @param go.enrich.lst The result of calling method goEnrichTest(...).
#' @param p.adjust.method The method to use when adjusting p-values for
#'        multiple hypothesis testing. Default is 'fdr' [see p.adjust for
#'        details]
#'
#' @return A data.frame with the merged enriched GO terms and adjusted
#' p-values.
#' @export
joinGOEnrichResults <- function(go.enrich.lst, p.adjust.method = "fdr") {
  res <- do.call("rbind", go.enrich.lst)
  if (!is.null(res)) 
    res$p.value.adjusted <- p.adjust(res$p.value, method = p.adjust.method)
  res
} 
