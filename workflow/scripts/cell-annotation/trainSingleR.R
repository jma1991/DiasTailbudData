#!/usr/bin/env Rscript

splitByCol <- function(x, f, drop = FALSE) {
    
    by.col <- split(seq_len(ncol(x)), f, drop = drop)
    
    out <- lapply(by.col, function(i) x[, i])
    
    List(out)
}

main <- function(input, output, params, log) {
    
    # Log function
    
    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(SingleR)

    sce <- readRDS(input$rds)

    ref <- splitByCol(sce, sce[[params$batch]])

    lab <- split(sce, sce[[params$label]])

    fit <- trainSingleR(ref = ref, labels = lab)

    saveRDS(fit, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)