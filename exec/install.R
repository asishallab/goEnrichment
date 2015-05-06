# Source this R script to install goEnrichment and all dependencies:
if (!require(devtools)) {
  install.packages("devtools")
  require(devtools)
}
if (!"RMySQL" %in% rownames(installed.packages)) install.packages("RMySQL")
packages <- c("GOstats", "GSEABase")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  source("http://bioconductor.org/biocLite.R")
  biocLite(setdiff(packages, rownames(installed.packages())))
}
install_github("asishallab/goEnrichment") 
