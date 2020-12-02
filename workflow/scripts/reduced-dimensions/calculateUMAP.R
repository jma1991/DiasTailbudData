#!/usr/bin/env Rscript

set.seed(1701)

main <- function(input, output) {

    pkg <- c("BiocParallel")

    lib <- lapply(pkg, library, character.only = TRUE)

    sce <- readRDS(input$rds)

    sce <- runUMAP(sce, dimred = "PCA", min_dist = params$min, n_neighbors = params$num)

    saveRDS(sce, output$rds)
    
}

main(snakemake@input, snakemake@output, snakemake@params)