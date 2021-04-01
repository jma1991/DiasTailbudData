#!/usr/bin/env Rscript

main <- function(input, output, params, log) {

    # Log function
    
    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(ggplot2)

    library(scales)

    dat <- readRDS(input$rds)

    dat <- subset(dat, !is.na(FDR))

    dat <- data.frame(Limited = dat$Limited, Significant = dat$FDR < params$FDR)

    col <- c("TRUE" = "#59A14F", "FALSE" = "#E15759")

    lab <- c("TRUE" = "True", "FALSE" = "False")

    plt <- ggplot(dat, aes(Limited, fill = Significant)) + 
        geom_bar() + 
        scale_fill_manual(values = col, labels = lab) + 
        scale_x_discrete(name = "Limited", labels = lab) + 
        scale_y_continuous(name = "Barcodes", labels = label_number_si()) + 
        theme_bw() + 
        theme(
            axis.title.x = element_text(margin = unit(c(1, 0, 0, 0), "lines")), 
            axis.title.y = element_text(margin = unit(c(0, 1, 0, 0), "lines")), 
            legend.justification = "top"
        )

    ggsave(output$pdf, plot = plt, width = 8, height = 6, scale = 0.8)

    # Image function

    library(magick)

    pdf <- image_read_pdf(output$pdf)
    
    pdf <- image_trim(pdf)

    pdf <- image_border(pdf, color = "#FFFFFF", geometry = "50x50")
    
    pdf <- image_write(pdf, path = output$pdf, format = "pdf")

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)