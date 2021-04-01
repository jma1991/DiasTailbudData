#!/usr/bin/env Rscript

main <- function(input, output, params, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(scater)

    dbl <- readRDS(input$rds)

    lgl <- isOutlier(dbl$num.de, nmads = params$nmads, type = "lower", log = TRUE)

    lab <- rownames(dbl)[lgl]

    saveRDS(lab, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)