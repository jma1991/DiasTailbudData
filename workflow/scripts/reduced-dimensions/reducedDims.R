#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(SingleCellExperiment)

    rds <- lapply(input$rds, readRDS)

    sce <- rds[[1]]

    dim <- list(
        "PCA"  = rds[[2]],
        "TSNE" = rds[[3]],
        "UMAP" = rds[[4]]
    )

    reducedDims(sce) <- dim

    saveRDS(sce, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log)