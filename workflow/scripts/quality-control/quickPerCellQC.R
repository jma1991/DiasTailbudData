#!/usr/bin/env Rscript

main <- function(input, output, params, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script functions

    library(scater)

    dat <- readRDS(input$rds)

    sub <- paste("subsets", params$subsets, "percent", sep = "")

    out <- quickPerCellQC(dat, sub.fields = sub, nmads = params$nmads)

    saveRDS(out, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)