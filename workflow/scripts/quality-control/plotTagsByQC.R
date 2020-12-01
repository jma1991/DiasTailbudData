#!/usr/bin/env Rscript

max.ind <- function(x, n = 10) {
    which(x >= sort(x, decreasing = TRUE)[n], arr.ind = TRUE)
}

min.ind <- function(x, n = 10) { 
    which(x <= sort(x, decreasing = FALSE)[n], arr.ind = TRUE)
}

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function
    
    library(ggplot2)

    library(ggrepel)
            
    dat <- read.csv(input$csv)
    
    ind <- list(
        max = max.ind(dat$logFC, n = 25), 
        min = min.ind(dat$logFC, n = 25)
    )

    ids <- dat$Symbol

    dat$Symbol <- ""

    dat$Symbol[ind$max] <- ids[ind$max]
    
    dat$Symbol[ind$min] <- ids[ind$min]
    
    plt <- ggplot(dat, aes(logCPM, logFC, label = Symbol)) + 
        geom_point(colour = "#BAB0AC") + 
        geom_text_repel() + 
        labs(x = "logCPM", y = "logFC (Lost/Kept)") + 
        theme_classic()

    ggsave(output$pdf, plot = plt, width = 4, heigh = 3, scale = 1.5)

}

main(snakemake@input, snakemake@output, snakemake@log)