#!/usr/bin/env Rscript

retrieveAnnotationObject <- function(x) {

    # Return genome wide annotation

    pkg <- paste0("org.", x, ".eg.db")
    
    stopifnot(requireNamespace(pkg, quietly = TRUE))

    obj <- getFromNamespace(pkg, pkg)

}

main <- function(input, output, params, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(AnnotationDbi)

    library(limma)

    org <- retrieveAnnotationObject(params$species)

    res <- readRDS(input$rds)

    sig <- lapply(res, subset, FDR < params$fdr)

    sig <- Filter(nrow, sig)

    ids.ENS <- lapply(sig, rownames)

    ids.ENT <- mapply(mapIds, keys = ids.ENS, MoreArgs = list(x = org, column = "ENTREZID", keytype = "ENSEMBL"), SIMPLIFY = FALSE)

    all.ENS <- Reduce(intersect, lapply(res, rownames))
    
    all.ENT <- mapIds(org, keys = all.ENS, column = "ENTREZID", keytype = "ENSEMBL")

    out <- mapply(goana, de = ids.ENT, MoreArgs = list(universe = all.ENT, species = params$species), SIMPLIFY = FALSE)

    saveRDS(out, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)