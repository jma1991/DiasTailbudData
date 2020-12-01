#!/usr/bin/env Rscript

breaks_log10 <- function() {

    # Return breaks for log10 scale

    function(x) 10^seq(ceiling(log10(min(x))), ceiling(log10(max(x))))

}

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
        threshold = attr(df2[, "low_lib_size"], "thresholds")["lower"], 
        ncells = sum(df2[, "low_lib_size"])
    )

    plt <- ggplot(as.data.frame(df1), aes(sum)) + 
        geom_histogram(bins = 100, colour = "#BAB0AC", fill = "#BAB0AC") + 
        geom_vline(xintercept = ann$threshold, linetype = "dashed", colour = "#000000") + 
        annotate("text", x = ann$threshold, y = Inf, label = sprintf("Threshold = %s ", comma(round(ann$threshold))), angle = 90, vjust = -1, hjust = 1, colour = "#000000") + 
        annotate("text", x = ann$threshold, y = Inf, label = sprintf("Discarded = %s ", comma(ann$ncells)), angle = 90, vjust = 2, hjust = 1, colour = "#000000") + 
        scale_x_log10(name = "Total counts", breaks = breaks_log10(), label = label_number_si()) + 
        scale_y_continuous(name = "Number of cells", breaks = breaks_extended(), label = label_number_si()) + 
        theme_custom()

    ggsave(output$pdf, plot = plt, width = 8, height = 6, scale = 0.8)

}

main(snakemake@input, snakemake@output, snakemake@log)