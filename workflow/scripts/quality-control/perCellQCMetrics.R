#!/usr/bin/env Rscript

main <- function(input, output, params, log, threads) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(scater)

    library(tools)

    sce <- readRDS(input$rds)

    sub <- lapply(input$txt, readLines)

    names(sub) <- file_path_sans_ext(basename(input$txt))

    out <- perCellQCMetrics(sce, subsets = sub)

    rownames(out) <- colnames(sce)
    
    saveRDS(out, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log, snakemake@threads)