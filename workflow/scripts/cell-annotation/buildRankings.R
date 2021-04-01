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

    sce <- readRDS(input$rds)

    fit <- AUCell_buildRankings(
        exprMat = counts(sce), 
        plotStats = FALSE, 
        verbose = TRUE
    )

    saveRDS(fit, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log)