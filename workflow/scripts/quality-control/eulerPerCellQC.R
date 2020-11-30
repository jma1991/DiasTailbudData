#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(eulerr)

    dat <- lapply(input$csv, read.csv)
    
    mat <- cbind(
        Keep   = TRUE,
        Manual = dat[[1]]$discard, 
        Quick  = dat[[2]]$discard, 
        Robust = dat[[3]]$discard
    )
    
    fit <- euler(mat)

    plt <- plot(fit, fills = list(fill = c("#BAB0AC", "#FF9DA7", "#B07AA1", "#76B7B2")), quantities = list(type = c("percent", "counts")))

    pdf(output$pdf)
    
    print(plt)

    dev.off()

}

main(snakemake@input, snakemake@output, snakemake@log)