#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(scuttle)

    library(slingshot)

    sce <- readRDS(input$rds)

    sce <- slingshot(sce, clusterLabels = "Cluster", reducedDim = "PCA", approx_points = 100)

    sds <- SlingshotDataSet(sce)

    saveRDS(sds, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log)