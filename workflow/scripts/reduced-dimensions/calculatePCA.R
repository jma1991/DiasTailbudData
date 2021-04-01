#!/usr/bin/env Rscript

set.seed(1701)

main <- function(input, output, params, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(scater)

    sce <- readRDS(input$rds)

    hvg <- rowSubset(sce, "HVG")

    dim <- calculatePCA(sce, ncomponents = params$ncomponents, subset_row = hvg, exprs_values = "corrected")

    rownames(dim) <- colnames(sce)

    colnames(dim) <- paste0("PCA.", seq_len(ncol(dim)))

    saveRDS(dim, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)
