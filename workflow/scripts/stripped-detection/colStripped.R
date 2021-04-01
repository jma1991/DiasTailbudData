#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(SingleCellExperiment)

    library(S4Vectors)

    sce <- readRDS(input$rds[1])

    fit <- readRDS(input$rds[2])

    sce$Stripped <- sce$Cluster %in% rownames(fit)[fit$stripped]

    saveRDS(sce, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log)