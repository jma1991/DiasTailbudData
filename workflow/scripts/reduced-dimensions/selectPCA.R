#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    dim <- readRDS(input$rds[1])

    num <- readRDS(input$rds[2])

    ind <- seq_len(num)

    dim <- dim[, ind]

    saveRDS(dim, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log)