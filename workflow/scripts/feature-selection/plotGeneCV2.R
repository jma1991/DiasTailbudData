#!/usr/bin/env Rscript

breaks_log10 <- function() {

    # Return breaks for log10 scale

    function(x) 10^seq(ceiling(log10(min(x))), ceiling(log10(max(x))))

}

labels_log10 <- function() {

    # Return labels for log10 scale

    options(scipen = 999)

    function(x) signif(x, digits = Inf)

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

    dec <- readRDS(input$rds[1])

    hvg <- readRDS(input$rds[2])

    dec$variable <- rownames(dec) %in% hvg

    lab <- list(
        "TRUE" = sprintf("Variable (%s)", comma(sum(dec$variable))),
        "FALSE" = sprintf("Non-variable (%s)", comma(sum(!dec$variable)))
    )

    col <- list(
        "TRUE" = "#E15759",
        "FALSE" = "#BAB0AC"
    )

    dec$name <- ""

    ind <- which(dec$ratio >= sort(dec$ratio, decreasing = TRUE)[params$n], arr.ind = TRUE)

    dec$name[ind] <- rownames(dec)[ind]

    plt <- ggplot(as.data.frame(dec)) + 
        geom_point(aes(x = mean, y = total, colour = variable)) + 
        geom_line(aes(x = mean, y = trend), colour = "#E15759") + 
        scale_colour_manual(values = col, labels = lab) + 
        geom_text_repel(aes(x = mean, y = total, label = name), colour = "#000000", size = 1) + 
        scale_x_log10(name = "Mean", breaks = breaks_log10(), label = labels_log10()) +
        scale_y_log10(name = "Total", breaks = breaks_log10(), label = labels_log10()) + 
        theme_bw() + 
        theme(legend.title = element_blank(), legend.position = "top")
    
    ggsave(filename = output$pdf, plot = plt, width = 8, height = 6, scale = 0.8)

    # Image function

    library(magick)

    pdf <- image_read_pdf(output$pdf)

    pdf <- image_trim(pdf)

    pdf <- image_border(pdf, color = "#FFFFFF", geometry = "50x50")

    pdf <- image_write(pdf, path = output$pdf, format = "pdf")

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)