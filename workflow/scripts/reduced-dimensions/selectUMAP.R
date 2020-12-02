#!/usr/bin/env Rscript

set.seed(1701)

main <- function(input, output, params, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    dim <- readRDS(input$rds)

    par <- data.frame(
        index = seq_along(dim),
        n_neighbors = sapply(dim, attr, "n_neighbors"),
        min_dist = sapply(dim, attr, "min_dist")
    )

    par <- subset(par, n_neighbors == params$n_neighbors)
    
    par <- subset(par, min_dist == params$min_dist)

    dim <- dim[[par$index]]

    attr(dim, "cluster_walktrap") <- NULL

    saveRDS(dim, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)