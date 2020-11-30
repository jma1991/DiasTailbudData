#!/usr/bin/env Rscript

set.seed(1701)

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(scran)

    dim <- readRDS(input$rds)

    fit <- getClusteredPCs(dim, min.rank = 1, max.rank = ncol(dim))

    num <- metadata(fit)$chosen

    saveRDS(fit, file = output$rds[1])

    saveRDS(num, file = output$rds[2])

}

main(snakemake@input, snakemake@output, snakemake@log)