#!/usr/bin/env Rscript

main <- function(input, output, log, threads, wildcards) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(BiocParallel)

    library(scran)

    dat <- readRDS(input$rds)

    res <- combineMarkers(
        de.lists = dat$statistics,
        pairs = dat$pairs,
        pval.field = "p.value",
        effect.field = "AUC",
        pval.type = wildcards$type,
        BPPARAM = MulticoreParam(workers = threads)
    )

    saveRDS(res, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log, snakemake@threads, snakemake@wildcards)