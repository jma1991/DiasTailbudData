#!/usr/bin/env Rscript

plotCurve <- function(data, pseudotime, curve) {

    data <- as.data.frame(data)

    data$Pseudotime <- pseudotime
    
    curve <- as.data.frame(curve$s[curve$ord, ])
    
    colnames(curve) <- c("x", "y")
    
    plt <- ggplot(data, aes(UMAP.1, UMAP.2, colour = Pseudotime)) + 
        geom_point() + 
        scale_colour_viridis_c() + 
        geom_path(data = curve, aes(x, y), colour = "black") + 
        theme_no_axes(theme_bw()) + 
        theme(aspect.ratio = 1)

    return(plt)

}

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(ggforce)

    library(patchwork)

    library(scater)

    library(slingshot)

    sce <- readRDS(input$rds[1])

    sds <- readRDS(input$rds[2])

    num <- length(sds@lineages)

    dat <- makePerCellDF(sce)

    dat <- replicate(num, dat, simplify = FALSE)

    mat <- slingPseudotime(sds)
    
    mat <- split(mat, col(mat))
    
    cur <- embedCurves(sds, newDimRed = reducedDim(sce, "UMAP"))
    
    cur <- slingCurves(cur)

    plt <- mapply(plotCurve, data = dat, pseudotime = mat, curve = cur, SIMPLIFY = FALSE)

    plt <- wrap_plots(plt)

    ggsave(output$pdf, plot = plt, width = 20, height = 20, scale = 0.8)

    # Image function

    library(magick)

    pdf <- image_read_pdf(output$pdf)

    pdf <- image_trim(pdf)

    pdf <- image_border(pdf, color = "#FFFFFF", geometry = "50x50")

    pdf <- image_write(pdf, path = output$pdf, format = "pdf")

}

main(snakemake@input, snakemake@output, snakemake@log)