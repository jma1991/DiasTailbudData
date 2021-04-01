#!/usr/bin/env Rscript

breaks_log10 <- function() {

    # Return breaks for log10 scale
    
    function(x) 10^seq(ceiling(log10(min(x))), ceiling(log10(max(x))))

}

theme_custom <- function() {

    # Return custom theme

    theme_bw() + 
    theme(
        axis.title.x = element_text(margin = unit(c(1, 0, 0, 0), "lines")), 
        axis.title.y = element_text(margin = unit(c(0, 1, 0, 0), "lines")), 
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

    bcr <- readRDS(input$rds)
    
    bcr <- subset(bcr, !duplicated(rank))

    dat <- as.data.frame(bcr)

    lab <- list(
        knee = sprintf("Knee = %s", comma(metadata(bcr)$knee)),
        inflection = sprintf("Inflection = %s", comma(metadata(bcr)$inflection)),
        lower = sprintf("Lower = %s", comma(metadata(bcr)$lower))
    )

    col <- list(
        knee = "#309143",
        inflection = "#E39802",
        lower = "#B60A1C"
    )

    plt <- ggplot(dat, aes(rank, total)) + 
        geom_point(shape = 1, colour = "#000000") + 
        geom_hline(yintercept = metadata(bcr)$knee, colour = col$knee, linetype = "dashed") + 
        geom_hline(yintercept = metadata(bcr)$inflection, colour = col$inflection, linetype = "dashed") + 
        geom_hline(yintercept = metadata(bcr)$lower, colour = col$lower, linetype = "dashed") + 
        annotate("text", x = 1, y = metadata(bcr)$knee, label = lab$knee, colour = col$knee, hjust = 0, vjust = -1) +
        annotate("text", x = 1, y = metadata(bcr)$inflection, label = lab$inflection, colour = col$inflection, hjust = 0, vjust = -1) + 
        annotate("text", x = 1, y = metadata(bcr)$lower, label = lab$lower, colour = col$lower, hjust = 0, vjust = -1) + 
        scale_x_log10(name = "Barcode Rank", breaks = breaks_log10(), labels = label_number_si()) + 
        scale_y_log10(name = "Total Count", breaks = breaks_log10(), labels = label_number_si()) + 
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