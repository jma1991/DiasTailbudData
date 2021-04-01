#!/usr/bin/env Rscript

main <- function(input, output, params, log, wildcards) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(bluster)

    dim <- readRDS(input$rds)

    par <- NNGraphParam(k = as.numeric(wildcards$k), type = wildcards$type, cluster.fun = wildcards$fun)

    out <- clusterRows(x = dim, BLUSPARAM = par, full = TRUE)

    saveRDS(out, output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log, snakemake@wildcards)