#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(scran)

    res <- readRDS(input$rds)

    dir.create(output$dir)

    ids <- paste0(output$dir, "/", names(res), ".tsv")
    
    mapply(write.table, x = res, file = ids, MoreArgs = list(quote = FALSE, sep = "\t", col.names = NA))

}

main(snakemake@input, snakemake@output, snakemake@log)