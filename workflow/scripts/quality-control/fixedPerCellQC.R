#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")
    
    # Script function

    library(scater)

    dat <- readRDS(input$rds)
    
    out <- DataFrame(
        low_lib_size = dat$sum < 1000,
        low_n_features = dat$detected < 500,
        high_subsets_MT_percent = dat$subsets_MT_percent > 10
    )

    out$discard <- apply(out, 1, any)

    saveRDS(out, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log)