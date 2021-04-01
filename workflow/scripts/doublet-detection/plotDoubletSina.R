#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(ggforce)

    library(ggplot2)

    library(scales)
    
    library(scuttle)

    sce <- readRDS(input$rds)

    dat <- makePerCellDF(sce)

    dat <- as.data.frame(dat)

    col <- c("TRUE" = "#E15759", "FALSE" = "#59A14F")

    lab <- c("TRUE" = "Yes", "FALSE" = "No")

    plt <- ggplot(dat, aes(Cluster, jitter(Density), colour = Doublet)) + 
        geom_sina() + 
        scale_colour_manual(values = col, labels = lab) + 
        labs(x = "Cluster", y = "Density") + 
        theme_bw() + 
        theme(legend.justification = "top")

    ggsave(output$pdf, plot = plt, width = 8, height = 6, scale = 0.8)

    # Image function

    library(magick)

    pdf <- image_read_pdf(output$pdf)

    pdf <- image_trim(pdf)

    pdf <- image_border(pdf, color = "#FFFFFF", geometry = "50x50")

    pdf <- image_write(pdf, path = output$pdf, format = "pdf")

}

main(snakemake@input, snakemake@output, snakemake@log)