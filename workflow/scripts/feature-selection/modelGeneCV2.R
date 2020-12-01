#!/usr/bin/env Rscript

main <- function(input, output, log, threads) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(BiocParallel)

    library(scran)

    sce <- readRDS(input$rds)

    par <- MulticoreParam(workers = threads)

    dec <- modelGeneCV2(sce, BPPARAM = par)

    dec <- cbind(id = rowData(sce)$ID, name = rowData(sce)$Symbol, dec)

    rownames(dec) <- rownames(sce)

    saveRDS(dec, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log, snakemake@threads)
