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
        perplexity = sapply(dim, attr, "perplexity"),
        max_iter = sapply(dim, attr, "max_iter")
    )

    par <- subset(par, perplexity == params$perplexity)
    
    par <- subset(par, max_iter == params$max_iter)

    dim <- dim[[par$index]]

    attr(dim, "cluster_walktrap") <- NULL

    saveRDS(dim, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)