#!/usr/bin/env Rscript

main <- function(input, output, params, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(robustbase)

    library(scater)

    dat <- readRDS(input$rds)

    sub <- paste("subsets", params$subsets, "percent", sep = "_")

    sub <- dat[, sub, drop = FALSE]

    out <- DataFrame(lib_size = log10(dat$sum), n_features = log10(dat$detected))

    out <- cbind(out, sub)

    adj <- adjOutlyingness(out, only.outlyingness = TRUE)

    out$discard <- isOutlier(adj, type = "higher", nmads = params$nmads)

    saveRDS(out, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)