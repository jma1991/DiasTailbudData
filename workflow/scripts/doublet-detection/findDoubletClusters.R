#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(scDblFinder)

    sce <- readRDS(input$rds)

    dbl <- findDoubletClusters(sce, clusters = sce$Cluster)

    saveRDS(dbl, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log)