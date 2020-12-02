#!/usr/bin/env Rscript

theme_custom <- function() {

    # Return custom theme

    theme_bw() +
    theme(
        axis.title.x = element_text(margin = unit(c(1, 0, 0, 0), "lines")),
        axis.title.y = element_text(margin = unit(c(0, 1, 0, 0), "lines")),
    )

}

plotHighestExprs <- function(x, n = 50) {

    # Plot the highest expressing features

    rownames(x) <- uniquifyFeatureNames(rowData(x)$ID, rowData(x)$Symbol)

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

    ggplot(dat, aes(prop, reorder(gene, prop, median))) + 
        geom_point(colour = "#BAB0AC", shape = 124) + 
        stat_summary(fun = "median", geom = "point") + 
        scale_x_continuous(labels = scales::label_percent()) + 
        scale_y_discrete(labels = ) + 
        labs(x = "Counts", y = "Feature") + 
        theme_custom()

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

    plt <- plotHighestExprs(sce, n = params$n)

    ggsave(output$pdf, plot = plt, width = 7.5, height = 10, scale = 0.8)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)