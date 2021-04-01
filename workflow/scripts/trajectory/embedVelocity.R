#!/usr/bin/env Rscript

main <- function(input, output, log, wildcards) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(velociraptor)

    sce <- readRDS(input$rds[1])

    vel <- readRDS(input$rds[2])

    mat <- embedVelocity(x = sce, vobj = vel, use.dimred = wildcards$reducedDim)
    
    saveRDS(mat, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log, snakemake@wildcards)