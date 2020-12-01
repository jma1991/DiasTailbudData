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
        legend.position = "top"
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

  id1 <- list(x = "sum", y = "detected")

  id2 <- list(x = "low_lib_size", y = "low_n_features")

  use <- list(x = "lower", y = "lower")

  ann <- list(
    threshold = list(
      x = attr(df2[, id2$x], "thresholds")[use$x],
      y = attr(df2[, id2$y], "thresholds")[use$y]
    ),
    discarded = list(
      x = df2[, id2$x],
      y = df2[, id2$y]
    ),
    ncells = list(
      x = sum(df2[, id2$x]),
      y = sum(df2[, id2$y])
    )
  )

  val <- c("TRUE" = "#BAB0AC", "FALSE" = "#4E79A7")

  lab <- c("TRUE" = "Filtered", "FALSE" = "Selected")

  df1$status <- ann$discarded$x | ann$discarded$y

  plt <- ggplot(as.data.frame(df1), aes_string(x = id1$x, y = id1$y, colour = "status")) +
    geom_point() +
    scale_colour_manual(name = "Status", values = val, labels = lab) +
    geom_vline(xintercept = ann$threshold$x, linetype = "dashed", colour = "#000000") +
    geom_hline(yintercept = ann$threshold$y, linetype = "dashed", colour = "#000000") +
    annotate("text", x = ann$threshold$x, y = Inf, label = sprintf("Threshold = %s ", comma(round(ann$threshold$x))), angle = 90, vjust = -1, hjust = 1, colour = "#000000") +
    annotate("text", x = ann$threshold$x, y = Inf, label = sprintf("Discarded = %s ", comma(ann$ncells$x)), angle = 90, vjust = 2, hjust = 1, colour = "#000000") +
    annotate("text", x = Inf, y = ann$threshold$y, label = sprintf("Threshold = %s ", comma(round(ann$threshold$y))), angle = 0, vjust = -1, hjust = 1, colour = "#000000") +
    annotate("text", x = Inf, y = ann$threshold$y, label = sprintf("Discarded = %s ", comma(ann$ncells$y)), angle = 0, vjust = 2, hjust = 1, colour = "#000000") +
    scale_x_log10(name = "Total counts", breaks = breaks_log10(), labels = label_number_si()) +
    scale_y_log10(name = "Total features", breaks = breaks_log10(), labels = label_number_si()) +
    theme_custom()

  ggsave(output$pdf, plot = plt, width = 8, height = 6, scale = 0.8)

}

main(snakemake@input, snakemake@output, snakemake@log)