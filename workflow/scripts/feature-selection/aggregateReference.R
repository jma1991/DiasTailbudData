#!/usr/bin/env Rscript

set.seed(1701)

main <- function(input, output, log, threads) {

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

    ref <- aggregateReference(sce, mem, assay.type = "corrected", BPPARAM = par)

    ref <- as(ref, "SingleCellExperiment")

    saveRDS(ref, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log, snakemake@threads)
