#!/usr/bin/env Rscript

main <- function(input, output, params, log, threads) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(MouseGastrulationData)

    AtlasSampleMetadata <- subset(AtlasSampleMetadata, stage %in% params$stage)

    sce <- EmbryoAtlasData(type = "processed", samples = AtlasSampleMetadata$sample)

    nan <- sce$doublet | sce$stripped | is.na(sce$celltype)

    sce <- sce[, !nan]

    sce <- logNormCounts(sce)

    saveRDS(sce, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log, snakemake@threads)