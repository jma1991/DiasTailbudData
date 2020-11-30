#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(AUCell)

    dat <- read.delim(input$tsv)

    dat <- split(dat$ID, dat$Celltype)

    fit <- AUCell_calcAUC(
        geneSets = dat, 
        rankings = readRDS(input$rds), 
        verbose = TRUE
    )

    saveRDS(fit, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log)