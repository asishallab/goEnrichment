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
      hgt <- GOstats::hyperGTest(Category::GSEAGOHyperGParams(name = "", 
        geneSetCollection = gsc, geneIds = gene.ids, universeGeneIds = univ.gene.ids, 
        ontology = go.ont, pvalueCutoff = pvalue.cutoff, conditional = cond, 
        testDirection = test.dir))
      hgt.tbl <- as.data.frame(summary(hgt))
      list(hyperGTest = hgt, hyperGTest.table = hgt.tbl)
    }, error = function(e) {
      warning("Error in goEnrichTest(...) when computing GO-Ontology ", go.ont, 
        " ", e)
      NA
    })
  }), ontologies)
}
 

#' Method extracts all GO ontology specific enrichment result and combines them
#' into a single data frame, re-adjusting the Pvalues for multiple hypothesis
#' testing.
#'
#' @param go.enrich.lst The result of calling method goEnrichTest(...).
#' @param ontology.tbl.entry The name of the list-entry in which to find the
#'        go-enrichment result as table.
#' @param p.adjust.method The method to use when adjusting p-values for
#'        multiple hypothesis testing.
#'
#' @return A data.frame with the merged enriched GO terms and adjusted
#' p-values.
#' @export
joinGOEnrichResults <- function(go.enrich.lst, ontology.tbl.entry = "hyperGTest.table", 
  p.adjust.method = "fdr") {
  go.enrich.tbl.colnames <- c("GO.Term.accession", "Pvalue", "OddsRatio", "ExpCount", 
    "Count", "Size", "Term")
  res <- do.call("rbind", lapply(go.enrich.lst, function(go.enrich.res) {
    if (!is.na(go.enrich.res) && !is.null(go.enrich.res)) {
      go.enrich.tbl <- go.enrich.res[[ontology.tbl.entry]]
      colnames(go.enrich.tbl) <- go.enrich.tbl.colnames
      go.enrich.tbl
    }
  }))
  res$Pvalue.FDR <- p.adjust(res$Pvalue, method = p.adjust.method)
  res
}
