library(SingleCellExperiment)
library(iSEE)
sce <- readRDS('data.rds')
iSEE(sce, appTitle = 'DiasTailbudData')
