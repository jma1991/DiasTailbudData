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

    pca <- readRDS(input$rds)

    par <- MulticoreParam(workers = threads)

    dim <- calculateTSNE(pca, transposed = TRUE, BPPARAM = par)

    rownames(dim) <- rownames(pca)

    colnames(dim) <- paste0("TSNE.", seq_len(ncol(dim)))

    saveRDS(dim, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log, snakemake@threads)