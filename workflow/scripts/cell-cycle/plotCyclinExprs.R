#!/usr/bin/env Rscript

sampleByCol <- function(x, f, drop = FALSE, size = 100) {

    by.col <- split(seq_len(ncol(x)), f, drop = drop)

    by.len <- sapply(by.col, length)

    by.min <- pmin(by.len, size)

    by.idx <- mapply(sample, x = by.col, size = by.min)

    i <- sort(unlist(by.idx))

    out <- x[, i]

}

orderByCol <- function(x, f) {

    # Return object ordered by column

    by.col <- order(f)

    out <- x[, by.col]

}

pheatmap.color <- function(x) {

    # Return color vector

    colorRampPalette(RColorBrewer::brewer.pal(n = 5, name = x))(100)

}

pheatmap.breaks <- function(x) {

    # Return breaks vector

    seq(0, max(x), length.out = 101)

}

pheatmap.annotation_col <- function(x) {

    # Return column annotation

    data.frame(
        Cluster = x$Cluster,
        row.names = colnames(x)
    )

}

main <- function(input, output, params, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(pheatmap)

    library(scuttle)

    sce <- readRDS(input$rds[1])

    sce <- sampleByCol(sce, f = sce$Cluster, size = params$size)

    sce <- orderByCol(sce, f = sce$Cluster)

    use <- grepl(params$pattern, rowData(sce)$Symbol)

    mat.x <- logcounts(sce)[use, ]

    rownames(mat.x) <- rowData(sce)$Symbol[use]

    mat.x <- mat.x[order(rownames(mat.x)), ]

    pheatmap(
        mat = mat.x,
        color = pheatmap.color("Reds"),
        breaks = pheatmap.breaks(mat.x),
        cluster_rows = FALSE,
        cluster_cols = FALSE,
        annotation_col = pheatmap.annotation_col(sce),
        show_rownames = TRUE,
        show_colnames = FALSE,
        filename = output$pdf,
        width = 8,
        height = 6
    )

    # Image function

    library(magick)

    pdf <- image_read_pdf(output$pdf)

    pdf <- image_trim(pdf)

    pdf <- image_border(pdf, color = "#FFFFFF", geometry = "50x50")

    pdf <- image_write(pdf, path = output$pdf, format = "pdf")

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)