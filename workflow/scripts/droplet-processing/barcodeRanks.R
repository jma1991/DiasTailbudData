#!/usr/bin/env Rscript

main <- function(input, output, params, log) {

    # Log function
    
    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(DropletUtils)

    sce <- readRDS(input$rds)

    out <- barcodeRanks(counts(sce), lower = params$lower)

    metadata(out)$lower <- params$lower

    saveRDS(out, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)