#!/usr/bin/env Rscript

theme_custom <- function() {

    # Return custom theme

    theme_bw() +
    theme(
        axis.title.x = element_text(margin = unit(c(1, 0, 0, 0), "lines")),
        axis.title.y = element_text(margin = unit(c(0, 1, 0, 0), "lines"))
    )

}

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(ggforce)

    library(scales)

    library(scuttle)

    sce <- readRDS(input$rds[1])

    dat <- readRDS(input$rds[2])

    ind <- colnames(sce)

    dat <- dat[ind, ]

    dat$cluster <- sce$Cluster

    dat$stripped <- sce$Stripped

    dat <- as.data.frame(dat)

    lab <- labeller(stripped = c("TRUE" = "Stripped", "FALSE" = "Not Stripped"))

    plt <- ggplot(dat, aes(cluster, subsets_MT_percent, colour = log10(sum))) + 
        geom_sina() + 
        scale_colour_viridis_c() + 
        scale_y_continuous(labels = label_percent(scale = 1)) + 
        labs(x = "Cluster", y = "MT Proportion", colour = "Library Size") + 
        facet_grid(cols = vars(stripped), scales = "free_x", space = "free_x", labeller = lab) + 
        theme_custom()
    
    ggsave(output$pdf, plot = plt, width = 8, height = 6, scale = 0.8)

}

main(snakemake@input, snakemake@output, snakemake@log)