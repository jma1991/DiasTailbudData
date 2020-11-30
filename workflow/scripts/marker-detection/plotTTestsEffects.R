#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(pheatmap)

    library(scran)

    res <- readRDS(input$rds)

    sig <- lapply(res, subset, FDR < 0.05)

    sig <- Filter(nrow, sig)

    lfc <- lapply(sig, getMarkerEffects, prefix = "logFC")

    row <- sapply(lfc, nrow) > 1

    dir <- dir.create(output$dir)

    ids <- paste0(output$dir, "/", names(sig), ".pdf")

    col <- colorRampPalette(rev(RColorBrewer::brewer.pal(n = 5, name = "RdBu")))(100)

    brk <- seq(-5, 5, length.out = 101)

    plt <- mapply(pheatmap, mat = lfc, cluster_rows = row, filename = ids, MoreArgs = list(color = col, breaks = brk, angle_col = 0, width = 8, height = 6))

    # Image function

    library(magick)

    pdf <- lapply(ids, image_read_pdf)

    pdf <- lapply(pdf, image_trim)

    pdf <- lapply(pdf, image_border, color = "#FFFFFF", geometry = "50x50")

    pdf <- mapply(image_write, image = pdf, path = ids, MoreArgs = list(format = "pdf"))

}

main(snakemake@input, snakemake@output, snakemake@log)