#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(ggplot2)

    library(scales)

    library(scran)

    dat <- readRDS(input$rds)

    num <- metadata(dat)$chosen

    plt <- ggplot(as.data.frame(dat), aes(n.pcs, n.clusters)) + 
        geom_point(colour = "#79706E") + 
        geom_vline(xintercept = num, colour = "#E15759", linetype = "dashed") + 
        annotate("text", x = num, y = Inf, label = sprintf("PCs = %s  ", num), angle = 90, vjust = -1, hjust = 1, colour = "#E15759") +
        scale_x_continuous(name = "Principal component", breaks = c(1, 10, 20, 30, 40, 50), labels = label_ordinal()) + 
        scale_y_continuous(name = "Number of clusters") + 
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