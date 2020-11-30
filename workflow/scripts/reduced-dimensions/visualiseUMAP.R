#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(ggplot2)

    library(ggforce)

    library(gtools)

    dim <- readRDS(input$rds)

    dat <- lapply(dim, function(x) {

        y <- as.data.frame(x)

        y$n_neighbors <- attr(x, "n_neighbors")

        y$min_dist <- attr(x, "min_dist")

        y$cluster_walktrap <- attr(x, "cluster_walktrap")

        y$params <- sprintf("[%s, %s]", y$n_neighbors, y$min_dist)

        return(y)

    })

    dat <- do.call(rbind, dat)

    dat$params <- factor(dat$params, levels = mixedsort(unique(dat$params)))

    plt <- ggplot(dat, aes(UMAP.1, UMAP.2, colour = cluster_walktrap)) + 
        geom_point(size = 0.1, show.legend = FALSE) + 
        facet_wrap(~ params, scales = "free") + 
        labs(caption = "UMAP parameters [n_neighbors, min_dist]") + 
        theme_no_axes(theme_bw()) + 
        theme(aspect.ratio = 1, strip.background = element_blank())

    ggsave(output$pdf, plot = plt, width = 12, height = 12, scale = 0.8)

    # Image function

    library(magick)

    pdf <- image_read_pdf(output$pdf)

    pdf <- image_trim(pdf)

    pdf <- image_border(pdf, color = "#FFFFFF", geometry = "50x50")

    pdf <- image_write(pdf, path = output$pdf, format = "pdf")

}

main(snakemake@input, snakemake@output, snakemake@log)