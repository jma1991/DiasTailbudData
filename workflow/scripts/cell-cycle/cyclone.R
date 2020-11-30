#!/usr/bin/env Rscript

main <- function(input, output, params, log, threads) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(BiocParallel)

    library(scran)

    sce <- readRDS(input$rds)
    
    rds <- system.file("exdata", params$rds, package = "scran")

    ids <- readRDS(rds)

    par <- MulticoreParam(workers = threads)

    fit <- cyclone(sce, ids, gene.names = rowData(sce)$ID, BPPARAM = par)

    saveRDS(fit, output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log, snakemake@threads)