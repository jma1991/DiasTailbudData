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

    sce <- readRDS(input$rds)

    fct <- factor(sce$Batch, levels = c("G1", "S", "G2M"))

    par <- MulticoreParam(workers = threads)

    dec <- modelGeneVar(sce, block = fct, BPPARAM = par)

    dec <- DataFrame(gene.id = rowData(sce)$ID, gene.name = rowData(sce)$Symbol, dec, row.names = rownames(sce))

    saveRDS(dec, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log, snakemake@threads)
