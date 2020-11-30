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

pheatmap.mat <- function(x) {

    # Scale rows by 'variance-aware' Z-transformation

    M <- rowMeans(x, na.rm = TRUE)

    DF <- ncol(x) - 1

    isNA <- is.na(x)

    if ( any(isNA) ) {

        mode(isNA) <- "integer"

        DF <-  DF - rowSums(isNA)

        DF[DF == 0] <- 1

    }

    x <- x - M

    V <- rowSums(x^2, na.rm = TRUE) / DF

    x <- x / sqrt(V + 0.01)

}

pheatmap.color <- function(x) {

    # Return color vector

    colorRampPalette(rev(RColorBrewer::brewer.pal(n = 5, name = x)))(100)

}

pheatmap.breaks <- function(x) {

    # Return breaks vector

    abs <- max(abs(x))

    abs <- min(abs, 5)

    seq(-abs, +abs, length.out = 101)

}

pheatmap.cluster_rows <- function(x) {

    # Return hclust object for rows

    hclust(dist(x, method = "euclidean"), method = "complete")

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

    res <- readRDS(input$rds[2])

    sig <- lapply(res, subset, FDR < 0.05)
    
    sig <- Filter(nrow, sig)

    ids <- lapply(sig, rownames)

    ids <- lapply(ids, head, n = 10)

    ids <- unique(unlist(ids))

    mat.x <- logcounts(sce)[ids, ]

    mat.z <- pheatmap.mat(mat.x)

    pheatmap(
        mat = mat.z,
        color = pheatmap.color("RdBu"),
        breaks = pheatmap.breaks(mat.z),
        cluster_rows = pheatmap.cluster_rows(mat.z),
        cluster_cols = FALSE,
        annotation_col = pheatmap.annotation_col(sce),
        show_rownames = TRUE,
        show_colnames = FALSE,
        filename = output$pdf,
        width = 12,
        height = 9
    )

    # Image function

    library(magick)

    pdf <- image_read_pdf(output$pdf)

    pdf <- image_trim(pdf)

    pdf <- image_border(pdf, color = "#FFFFFF", geometry = "50x50")

    pdf <- image_write(pdf, path = output$pdf, format = "pdf")

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)