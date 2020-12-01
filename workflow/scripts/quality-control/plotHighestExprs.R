#!/usr/bin/env Rscript

plotHighestExprs <- function(x, n) {

    # Plot the highest expressing features

    mat <- counts(x)
    
    lib <- DelayedMatrixStats::colSums2(mat)
    
    sum <- DelayedMatrixStats::rowSums2(mat)
    
    ord <- order(sum, decreasing = TRUE)
    
    idx <- head(ord, n = n)
    
    mat <- mat[idx, ]
    
    mat <- sweep(mat, 2, lib, `/`)
    
    dat <- data.frame(
        prop = as.numeric(mat), 
        gene = rep(rownames(mat), ncol(mat))
    )

    ggplot(dat, aes(prop, reorder(gene, prop, mean), fill = gene)) + 
        geom_boxplot(show.legend = FALSE) + 
        scale_x_continuous(labels = scales::label_percent()) + 
        scale_y_discrete(labels = ) + 
        labs(x = "Total counts (%)", y = "Feature") + 
        theme_bw()

}

main <- function(input, output, params, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(scater)

    sce <- readRDS(input$rds)

    rownames(sce) <- uniquifyFeatureNames(rowData(sce)$ID, rowData(sce)$Symbol)

    plt <- plotHighestExprs(sce, n = params$n)

    ggsave(output$pdf, plot = plt, width = 8, height = 6, scale = 0.8)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)