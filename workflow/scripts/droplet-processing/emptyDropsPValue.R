#!/usr/bin/env Rscript

theme_custom <- function() {

    # Return custom theme

    theme_bw() + 
    theme(
        axis.title.x = element_text(margin = unit(c(1, 0, 0, 0), "lines")), 
        axis.title.y = element_text(margin = unit(c(0, 1, 0, 0), "lines")), 
        legend.position = "top"
    )

}

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(ggplot2)

    library(scales)

    dat <- readRDS(input$rds)

    dat <- subset(dat, Total <= metadata(dat)$lower & Total > 0)

    dat <- as.data.frame(dat)

    plt <- ggplot(dat, aes(PValue)) + 
        geom_histogram(bins = 50, colour = "#000000", fill = "#BAB0AC") + 
        scale_x_continuous(name = "P value", breaks = breaks_extended(), labels = label_number()) + 
        scale_y_continuous(name = "Frequency", breaks = breaks_extended(), labels = label_number_si()) + 
        theme_custom()

    ggsave(output$pdf, plot = plt, width = 8, height = 6, scale = 0.8)

    # Image function

    library(magick)

    pdf <- image_read_pdf(output$pdf)
    
    pdf <- image_trim(pdf)

    pdf <- image_border(pdf, color = "#FFFFFF", geometry = "50x50")
    
    pdf <- image_write(pdf, path = output$pdf, format = "pdf")

}

main(snakemake@input, snakemake@output, snakemake@log)