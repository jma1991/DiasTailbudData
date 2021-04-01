#!/usr/bin/env Rscript

set.seed(1701)

main <- function(input, output, log, threads) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(BiocParallel)

    library(scater)

    sce <- readRDS(input$rds[1])

    hvg <- readRDS(input$rds[2])

    par <- MulticoreParam(workers = threads)

    dim <- calculatePCA(sce, subset_row = hvg, BPPARAM = par, exprs_values = "corrected")

    rownames(dim) <- colnames(sce)

    colnames(dim) <- paste0("PCA.", seq_len(ncol(dim)))

    saveRDS(dim, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log, snakemake@threads)
