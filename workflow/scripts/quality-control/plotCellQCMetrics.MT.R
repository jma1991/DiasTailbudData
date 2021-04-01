#!/usr/bin/env Rscript

theme_custom <- function() {

    # Return custom theme

    theme_bw() +
    theme(
        axis.title.x = element_text(margin = unit(c(1, 0, 0, 0), "lines")),
        axis.title.y = element_text(margin = unit(c(0, 1, 0, 0), "lines")),
    )

}

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(ggplot2)

    library(scales)

    df1 <- readRDS(input$rds[1])

    df2 <- readRDS(input$rds[2])

    ann <- list(
        threshold = attr(df2[, "high_subsets_MT_percent"], "thresholds")["higher"], 
        ncells = sum(df2[, "high_subsets_MT_percent"])
    )

    plt <- ggplot(as.data.frame(df1), aes(subsets_MT_percent)) + 
        geom_histogram(bins = 100, colour = "#BAB0AC", fill = "#BAB0AC") + 
        geom_vline(xintercept = ann$threshold, linetype = "dashed", colour = "#000000") + 
        annotate("text", x = ann$threshold, y = Inf, label = sprintf("Threshold = %s ", comma(round(ann$threshold))), angle = 90, vjust = -1, hjust = 1, colour = "#000000") + 
        annotate("text", x = ann$threshold, y = Inf, label = sprintf("Discarded = %s ", comma(ann$ncells)), angle = 90, vjust = 2, hjust = 1, colour = "#000000") + 
        scale_x_continuous(name = "MT proportion", breaks = breaks_extended(), label = label_percent(scale = 1)) + 
        scale_y_continuous(name = "Number of cells", breaks = breaks_extended(), label = label_number_si()) + 
        theme_custom()

    ggsave(output$pdf, plot = plt, width = 8, height = 6, scale = 0.8)

}

main(snakemake@input, snakemake@output, snakemake@log)