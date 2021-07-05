#!/usr/bin/env Rscript

main <- function(input, output, params) {

    library(rsconnect)
    
    options(
        repos = BiocManager::repositories(),
        needs.promptUser = FALSE
    )
    
    file.copy(
        from = input$rds, 
        to = output$rds, 
        overwrite = TRUE
    )
    
    txt <- c(
        "library(iSEE)",
        "library(SingleCellExperiment)",
        "library(ResidualMatrix)",
        "sce <- readRDS('sce.rds')",
        "ind <- which(rowData(sce)$ID == 'ENSMUSG00000062327')",
        "rowData(sce)$Symbol[ind] <- 'Bra'",
        "rownames(sce) <- scuttle::uniquifyFeatureNames(ID = rowData(sce)$ID, names = rowData(sce)$Symbol)",
        "iSEE(sce, appTitle = 'DiasTailbudData')"
    )

    writeLines(txt, con = output$txt)

    deployApp(
        appDir = params$dir, 
        appName = "DiasTailbudData", 
        appTitle = "DiasTailbudData", 
        launch.browser = FALSE, 
        forceUpdate = TRUE
    )

    configureApp(
        appName = "DiasTailbudData", 
        appDir = params$dir, 
        size = "xxxlarge"
    )

}

main(snakemake@input, snakemake@output, snakemake@params)