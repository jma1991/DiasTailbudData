#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(AUCell)

    library(SingleCellExperiment)

    sce <- readRDS(input$rds[1])

    res <- readRDS(input$rds[2])

    mat <- t(assay(res))

    ind <- max.col(mat)

    lab <- colnames(mat)[ind]

    sce$Celltype <- lab

    saveRDS(sce, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log)
