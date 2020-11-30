#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(scDblFinder)

    library(SingleCellExperiment)

    sce <- readRDS(input$rds)

    hvg <- rowSubset(sce, "HVG")

    dim <- reducedDim(sce, "PCA")

    num <- ncol(dim)

    fit <- computeDoubletDensity(sce, subset.row = hvg, dims = num)

    saveRDS(fit, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log)