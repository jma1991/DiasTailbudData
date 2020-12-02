#!/usr/bin/env Rscript

main <- function(input, output, params, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    options(repos = BiocManager::repositories())

    rsconnect::setAccountInfo(
        name = "jashmore",
        token = <TOKEN>,
        secret = <SECRET>
    )

    file.copy(input$rds, output$rds, overwrite = TRUE)

    cmd <- c(
        "library(SingleCellExperiment)",
        "library(iSEE)",
        "sce <- readRDS('data.rds')",
        sprintf("iSEE(sce, appTitle = '%s')", params$appTitle)
    )

    writeLines(cmd, con = output$txt)

    rsconnect::deployApp(appDir = params$appDir, appName = params$appName, appTitle = params$appTitle, launch.browser = FALSE, forceUpdate = TRUE)

    rsconnect::configureApp(appName = params$appName, appDir = params$appDir, size = "3xlarge")

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)
