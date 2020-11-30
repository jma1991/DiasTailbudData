#!/usr/bin/env Rscript

main <- function(input, output, params) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(Rtsne)

    dim <- readRDS(input$rds)

    run <- Rtsne(X = dim, perplexity = , max_iter = )

    saveRDS(sce, output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params)