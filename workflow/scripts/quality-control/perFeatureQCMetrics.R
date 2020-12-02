#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(scater)

    sce <- readRDS(input$rds)

    out <- perFeatureQCMetrics(sce)

    out <- DataFrame(
        gene.id = rowData(sce)$ID, 
        gene.name = rowData(sce)$Symbol, 
        out, 
        row.names = rownames(sce)
    )

    saveRDS(out, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log)