#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    pkg <- paste0("org.", species, ".eg.db")

    stopifnot(requireNamespace(pkg))
    
    obj <- getFromNamespace(pkg, pkg)

    sce <- readRDS(input$rds)

    sel <- select(obj, keys = rownames(sce), keytype = "ENSEMBL", columns = "GOALL")

    sel <- split(sel[,1], sel[,2])

    saveRDS(sel, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log)
