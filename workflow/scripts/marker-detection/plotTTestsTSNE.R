#!/usr/bin/env Rscript

plotTSNE <- function(object, features, filename) {

    dat <- makePerCellDF(object, features)
    
    lst <- lapply(features, function(x) ggplot(dat, aes_string("TSNE.1", "TSNE.2", colour = x)) + geom_point(show.legend = FALSE) + scale_colour_viridis_c() + labs(title = x) + theme_no_axes(theme_bw()) + theme(aspect.ratio = 1))

    plt <- wrap_plots(lst, ncol = 5, nrow = 5)

    ggsave(filename, plot = plt, width = 15, height = 15, scale = 0.8)

}

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(ggforce)

    library(ggplot2)

    library(patchwork)

    library(scuttle)

    sce <- readRDS(input$rds[1])

    res <- readRDS(input$rds[2])

    ids <- lapply(res, subset, FDR < 0.05)

    ids <- Filter(nrow, ids)

    ids <- lapply(ids, head, n = 25)

    ids <- lapply(ids, rownames)

    dir <- dir.create(output$dir)

    fns <- paste0(output$dir, "/", names(ids), ".pdf")

    plt <- mapply(plotTSNE, features = ids, filename = fns, MoreArgs = list(object = sce))

    # Image function

    library(magick)

    pdf <- lapply(fns, image_read_pdf)

    pdf <- lapply(pdf, image_trim)

    pdf <- lapply(pdf, image_border, color = "#FFFFFF", geometry = "50x50")

    pdf <- mapply(image_write, image = pdf, path = fns, MoreArgs = list(format = "pdf"))

}

main(snakemake@input, snakemake@output, snakemake@log)