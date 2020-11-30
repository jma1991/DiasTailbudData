#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(bluster)

    mem <- readRDS(input$rds)

    mat <- pairwiseModularity(mem$objects$graph, mem$clusters, as.ratio = TRUE)

    saveRDS(mat, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log)