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
    
    dat <- read.csv(input$csv)

    use <- !dat$discard

    nan <- dat$discard

    mat <- cbind(
        pass = calculateAverage(counts(sce)[, use]),
        fail = calculateAverage(counts(sce)[, nan])
    )
    
    cpm <- edgeR::cpm(mat, log = TRUE, prior.count = 1)

    ave <- rowMeans(cpm)

    lfc <- mat[, "fail"] - mat[, "pass"]

    res <- data.frame(ID = rowData(sce)$ID, Symbol = rowData(sce)$Symbol, logCPM = ave, logFC = lfc)

    write.csv(res, file = output$csv, quote = FALSE, row.names = FALSE)

}

main(snakemake@input, snakemake@output, snakemake@log)