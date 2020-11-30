#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(ggplot2)

    library(scuttle)

    sce <- readRDS(input$rds)

    dat <- makePerCellDF(sce)

    dat <- as.data.frame(dat)

    lab <- c("G1" = "G1", "S" = "S", "G2M" = "G2/M")

    col <- c("G1" = "#E03531", "S" = "#F0BD27", "G2M" = "#51B364")

    dat$Phase <- factor(dat$Phase, levels = c("G1", "S", "G2M"))

    plt <- ggplot(dat, aes(PCA.1, PCA.2, colour = Phase)) + 
        geom_point(data = dat[, c("PCA.1", "PCA.2")], aes(PCA.1, PCA.2), colour = "#BAB0AC") + 
        geom_point(show.legend = FALSE) + 
        scale_colour_manual(labels = lab, values = col) + 
        labs(x = "PCA 1", y = "PCA 2") + 
        facet_wrap(~ Phase) + 
        coord_fixed() + 
        theme_bw() + 
        theme(strip.background = element_blank())

    ggsave(file = output$pdf, plot = plt, width = 10, height = 10, scale = 0.8)

    # Image function

    library(magick)

    pdf <- image_read_pdf(output$pdf)

    pdf <- image_trim(pdf)

    pdf <- image_border(pdf, color = "#FFFFFF", geometry = "50x50")

    pdf <- image_write(pdf, path = output$pdf, format = "pdf")

}

main(snakemake@input, snakemake@output, snakemake@log)