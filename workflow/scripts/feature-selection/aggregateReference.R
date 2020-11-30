#!/usr/bin/env Rscript

main <- function(input, output, params, log, threads) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(BiocParallel)

    library(scran)

    library(SingleR)

    sce <- readRDS(input$rds)

    mem <- quickCluster(sce)

    par <- MulticoreParam(workers = threads)

    ref <- aggregateReference(sce, mem, BPPARAM = par)

    ref <- as(ref, "SingleCellExperiment")

    saveRDS(ref, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log, snakemake$threads)