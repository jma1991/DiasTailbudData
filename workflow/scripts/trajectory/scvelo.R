#!/usr/bin/env Rscript

main <- function(input, output, log, threads) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(BiocParallel)

    library(scuttle)

    library(velociraptor)

    sce <- readRDS(input$rds)

    hvg <- rowSubset(sce, "HVG")

    par <- MulticoreParam(workers = threads)

    sce <- scvelo(x = sce, subset.row = hvg, use.dimred = "PCA", BPPARAM = par)

    saveRDS(sce, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log, snakemake@threads)
