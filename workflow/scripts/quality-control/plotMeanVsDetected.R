#!/usr/bin/env Rscript

plotMeanVsDetected <- function(x, n = 50) {

    x <- subset(x, mean > 0)
    
    fit <- mgcv::gam(x$detected ~ s(log10(x$mean), bs = "cs"))
    
    x$residuals <- ""

    ind <- which(abs(fit$residuals) >= sort(abs(fit$residuals), decreasing = TRUE)[n], arr.ind = TRUE)

    x$residuals[ind] <- x$gene.name[ind]

    x <- as.data.frame(x)

    plt <- ggplot(x, aes(mean, detected, label = residuals)) + 
        geom_point(colour = "#BAB0AC") + 
        geom_text_repel(size = 2) + 
        scale_x_log10(name = "Mean", breaks = trans_breaks("log10", function(x) 10^x), labels = trans_format("log10", math_format(10^.x))) + 
        scale_y_continuous(name = "Detected", labels = label_percent(scale = 1)) + 
        theme_bw()

}

main <- function(input, output, params, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(ggplot2)

    library(ggrepel)

    library(scales)

    library(scater)

    dat <- readRDS(input$rds)

    plt <- plotMeanVsDetected(dat, n = params$n)

    ggsave(output$pdf, plot = plt, width = 8, height = 6, scale = 0.8)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)