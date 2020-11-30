#!/usr/bin/env Rscript

main <- function(input, output, params, log, threads) {
    
    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(BiocParallel)

    library(bluster)

    library(Rtsne)

    dim <- readRDS(input$rds)

    mem <- clusterRows(dim, NNGraphParam())

    arg <- expand.grid(perplexity = params$perplexity, max_iter = params$max_iter)

    par <- MulticoreParam(threads, RNGseed = 1701)

    run <- bpmapply(
        FUN = Rtsne,
        perplexity = arg$perplexity,
        max_iter = arg$max_iter,
        MoreArgs = list(X = dim, pca = FALSE),
        SIMPLIFY = FALSE,
        BPPARAM = par
    )

    idx <- seq_along(run)

    for (i in idx) { run[[i]] <- run[[i]]$Y }

    for (i in idx) { rownames(run[[i]]) <- rownames(dim) }

    for (i in idx) { colnames(run[[i]]) <- c("TSNE.1", "TSNE.2") }

    for (i in idx) { attr(run[[i]], "perplexity") <- arg$perplexity[i] }

    for (i in idx) { attr(run[[i]], "max_iter") <- arg$max_iter[i] }

    for (i in idx) { attr(run[[i]], "cluster_walktrap") <- mem }

    saveRDS(run, output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log, snakemake@threads)