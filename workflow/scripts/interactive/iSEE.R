library(iSEE)

library(SingleCellExperiment)

library(shiny)

sce <- readRDS("data.rds")

iSEE(sce, appTitle = "EHF-NMP", colormap = ecm)