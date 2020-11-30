#!/usr/bin/env Rscript

main <- function(input, output, log, wildcards) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(ggplot2)

    dim <- readRDS(input$rds[1])

    mem <- readRDS(input$rds[2])

    dat <- data.frame(dim, cluster = mem$clusters)

    plt <- ggplot(dat, aes(PCA.1, PCA.2, colour = cluster)) + 
        geom_point() + 
        labs(x = "PCA 1", y = "PCA 2", colour = "Cluster") + 
        coord_fixed() + 
        theme_bw()

    ggsave(file = output$pdf, plot = plt, width = 8, height = 6, scale = 0.8)

    # Image function

    library(magick)

    pdf <- image_read_pdf(output$pdf)
    
    pdf <- image_trim(pdf)

    pdf <- image_border(pdf, color = "#FFFFFF", geometry = "50x50")
    
    pdf <- image_write(pdf, path = output$pdf, format = "pdf")

}

main(snakemake@input, snakemake@output, snakemake@log, snakemake@wildcards)