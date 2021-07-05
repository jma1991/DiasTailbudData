#!/usr/bin/env Rscript

main <- function(input, output, log, threads) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(BiocParallel)

    library(scuttle)

    library(velociraptor)

    sce <- readRDS(input$rds[1])

    vel <- readRDS(input$rds[2])

    row <- intersect(rownames(sce), rownames(vel))

    col <- intersect(colnames(sce), colnames(vel))

    sce <- sce[row, col]

    vel <- vel[row, col]

    assay(sce, "spliced") <- assay(vel, "spliced")

    assay(sce, "unspliced") <- assay(vel, "unspliced")

    hvg <- rowSubset(sce, "HVG")

    par <- MulticoreParam(workers = threads)

    sce <- scvelo(x = sce, subset.row = hvg, use.dimred = "PCA", BPPARAM = par)

    saveRDS(sce, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log, snakemake@threads)
