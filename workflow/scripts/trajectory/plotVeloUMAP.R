#!/usr/bin/env Rscript

main <- function(input, output, log, wildcards) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(ggplot2)

    library(scuttle)

    library(velociraptor)

    sce <- readRDS(input$rds[1])

    vec <- readRDS(input$rds[2])

    dat <- makePerCellDF(sce)

    dat <- as.data.frame(dat)

    plt <- ggplot(dat, aes(UMAP.1, UMAP.2)) + 
        geom_point(colour = "#BAB0AC") + 
        geom_segment(
            data = vec, 
            mapping = aes(x = start.UMAP.1, y = start.UMAP.2, xend = end.UMAP.1, yend = end.UMAP.2), 
            arrow = arrow(length = unit(0.02, "inches"), type = "closed"),
            inherit.aes = FALSE,
        ) + 
        labs(x = "UMAP 1", y = "UMAP 2") + 
        theme_bw() + 
        theme(aspect.ratio = 1)

    ggsave(file = output$pdf, plot = plt, width = 8, height = 6, scale = 0.8)

    # Image function

    library(magick)

    pdf <- image_read_pdf(output$pdf)

    pdf <- image_trim(pdf)

    pdf <- image_border(pdf, color = "#FFFFFF", geometry = "50x50")

    pdf <- image_write(pdf, path = output$pdf, format = "pdf")

}

main(snakemake@input, snakemake@output, snakemake@log, snakemake@wildcards)