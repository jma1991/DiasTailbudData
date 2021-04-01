#!/usr/bin/env Rscript

main <- function(input, output, params, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(ggplot2)

    res <- readRDS(input$rds)

    dat <- data.frame(G1 = res$score$G1, G2M = res$score$G2M, phase = res$phases)

    col <- c("G1" = "#E03531", "S" = "#F0BD27", "G2M" = "#51B364")

    brk <- c("G1", "S", "G2M")

    lab <- sapply(brk, function(x) {
        
        num <- sum(x == dat$phase)
        
        pct <- (num / length(dat$phase)) * 100
        
        lab <- paste0(x, " (", round(pct, digits = 2), "%)")
        
        lab <- sub("G2M", "G2/M", lab)

    })

    plt <- ggplot(dat, aes(G1, G2M, colour = phase)) + 
        geom_point() + 
        scale_colour_manual(values = col, breaks = brk, labels = lab) + 
        labs(x = "G1 score", y = "G2/M score", colour = "Phase") + 
        theme_bw() + 
        theme(aspect.ratio = 1, legend.position = "top")

    ggsave(output$pdf, plot = plt, width = 8, height = 6, scale = 0.8)

    # Image function

    library(magick)

    pdf <- image_read_pdf(output$pdf)

    pdf <- image_trim(pdf)

    pdf <- image_border(pdf, color = "#FFFFFF", geometry = "50x50")

    pdf <- image_write(pdf, path = output$pdf, format = "pdf")

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)