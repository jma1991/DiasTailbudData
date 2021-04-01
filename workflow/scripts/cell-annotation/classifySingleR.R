#!/usr/bin/env Rscript

main <- function(input, output, log, threads) {
    
    # Log function
    
    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(BiocParallel)

    library(SingleR)

    sce <- readRDS(input$rds[1])

    ref <- readRDS(input$rds[2])

    set.seed(1701)

    out <- classifySingleR(sce, ref, BPPARAM = MulticoreParam(workers = threads))

    saveRDS(out, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log, snakemake@threads)