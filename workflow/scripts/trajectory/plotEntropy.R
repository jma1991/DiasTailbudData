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

    library(scuttle)

    sce <- readRDS(input$rds[1])

    res <- readRDS(input$rds[2])

    dat <- makePerCellDF(sce)

    dat$Entropy <- res

    plt <- ggplot(dat, aes(Cluster, Entropy, colour = Cluster)) + 
        geom_sina(show.legend = FALSE) + 
        stat_summary(fun = median, geom = "point", colour = "#000000", show.legend = FALSE) + 
        theme_bw()

    ggsave(output$pdf, plot = plt, width = 8, height = 6, scale = 0.8)

    # Image function

    library(magick)

    pdf <- image_read_pdf(output$pdf)

    pdf <- image_trim(pdf)

    pdf <- image_border(pdf, color = "#FFFFFF", geometry = "50x50")

    pdf <- image_write(pdf, path = output$pdf, format = "pdf")

}

main(snakemake@input, snakemake@output, snakemake@log)