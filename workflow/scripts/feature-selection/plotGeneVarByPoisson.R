#!/usr/bin/env Rscript

set.seed(1701)

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

    library(scran)

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

    ind <- which(dec$bio >= sort(dec$bio, decreasing = TRUE)[params$n], arr.ind = TRUE)
    
    dec$name[ind] <- dec$gene.name[ind]

    plt <- ggplot(as.data.frame(dec)) + 
        geom_point(aes(x = mean, y = total, colour = variable)) + 
        geom_line(aes(x = mean, y = tech), colour = "#E15759") + 
        scale_colour_manual(values = col, labels = lab) + 
        geom_text_repel(aes(x = mean, y = total, label = name), colour = "#000000", size = 2, segment.size = 0.2) + 
        labs(x = "Mean", y = "Total") + 
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
