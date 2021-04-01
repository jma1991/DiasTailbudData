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

    lab <- c("G1" = "G1", "S" = "S", "G2M" = "G2/M")
    
    col <- c("G1" = "#E03531", "S" = "#F0BD27", "G2M" = "#51B364")
    
    brk <- c("G1", "S", "G2M")

    plt <- ggplot(dat, aes(Cluster, fill = factor(Phase, levels = brk))) + 
        geom_bar(position = "fill") + 
        scale_fill_manual(name = "Phase", labels = lab, values = col, breaks = brk) + 
        scale_y_continuous(name = "Proportion", labels = label_percent()) + 
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