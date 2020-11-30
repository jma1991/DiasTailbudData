#!/usr/bin/env Rscript

main <- function(input, output, params, log, wildcards) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(bluster)

    dim <- readRDS(input$rds[1])

    fit <- readRDS(input$rds[2])

    sil <- approxSilhouette(dim, fit$clusters)

    saveRDS(sil, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log, snakemake@wildcards)